//
//  RequestViewModel.swift
//  SongLinkr
//
//  Created by Harry Day on 19/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Foundation
import SwiftUI
import SongLinkrNetworkCore
import ShazamKit
import AVFoundation

@MainActor
class RequestViewModel: NSObject, ObservableObject {
    // MARK: Published Properties
    
    /// The object to pass to results view
    @Published private(set) var resultsObject: ResultsModel?
    
    /// The description of an error to be shown
    @Published var errorDescription: (String, String)?
    
    /**
     The entity that the request originated from
     - Note: Used to decide if the origin platform was the default or not
     */
    @Published private(set) var originEntityID: String = ""
    
    /// Declares if the shazam process is in progress
    @Published var shazamState: ShazamState = .idle
    
    /// Declares if the normal process is in progress
    @Published var normalInProgress = false
    
    /// Last Snapshot of the `UserSettings`
    var userSettingsSnapshot: UserSettings?
    
    
    // MARK: Private Properties
    /// The network to make requests through
    private let network: Network
    
    /// The audio engine to access the microphone
    private var audioEngine: AVAudioEngine
    
    /// The Shazam Session
    private var session: SHSession
    
    
    // MARK: Computed Properties
    
    /**
     Declares whether to show the search results or not
        - Is true when `resultsObject` is not nil
        - When set to false, sets `resultsObject` to nil
     */
    var showResults: Binding<Bool> { Binding(
        get: {
            self.resultsObject != nil
        },
        set: { newValue in
            if !newValue {
                self.resultsObject = nil
                self.shazamState = .idle
            }
        }
        )
    }
    
    /// Declares whether an error has occured
    var showError: Binding<Bool> { Binding(
        get: { self.errorDescription != nil },
        set: { if !$0 { self.errorDescription = nil }}
    )
    }
    
    // MARK: Initialise
    /**
     Create a `RequestViewModel` class
     - Parameter network: The network layer to use for retrieving results. Defaults to `Network()`
     */
    init(
        network: Network = Network(),
        session: SHSession = SHSession(),
        audioEngine: AVAudioEngine = AVAudioEngine()
    ) {
        self.network = network
        self.session = session
        self.audioEngine = audioEngine
    }
    
    // MARK: Normal Requests
    /**
     Retrieve the search results from the API, sort them and set them to the published property
     - Parameters:
        - searchString: The string the user has inputted
        - settings: The current `UserSettings` object
        - title: The title of the track if it is already known
        - artist: The name of the artist if already known
        - artworkURL: The URL to the artwork if already known
     */
    func getResults(
        for searchString: String,
        with settings: UserSettings?,
        title: String? = nil,
        artist: String? = nil,
        artworkURL: URL? = nil
    ) async {
        let endpoint = generateEndpoint(with: searchString)
        
        do {
            // Get response
            var results = try await makeRequest(with: endpoint, title: title, artist: artist, knownArtworkURL: artworkURL)
            
            // Sort correctly
            if let settings = settings, settings.sortOption == .popularity {
                results.response.sort(by: <)
            } else {
                results.response.sort {
                    $0.id.rawValue < $1.id.rawValue
                }
            }
            
            // Put default at top
            if let settings = settings, settings.defaultAtTop {
                results.response.moveDefaultFirst(with: settings.defaultPlatform)
            }
            
            self.resultsObject = results
        } catch {
            // Catch errors
            // If dataloader error then decode it
            if error is Network.DataLoaderError {
                self.errorDescription = network.createErrorMessage(from: error as! Network.DataLoaderError)
            } else {
                self.errorDescription = ("Something went wrong", "Please try again. If the issue persists please send me an email from the settings page")
            }
        }
    }
    
    /**
     Generate an endpoint object for a given string input
     - Parameter input: The inputted URL (will be given as a string)
     - Returns: An `Endpoint` object to retrieve search results from
     */
    private func generateEndpoint(with input: String) -> Endpoint {
        let encodedString = Network.encodeURL(from: input)
        return .search(with: encodedString)
    }
    
    /**
     Make a request to the server with the specified endpoint
     - Parameters:
        - endpoint: The endpoint to request data from
        - title: The title of the track if it is already known
        - artist: The name of the artist if already known
        - artworkURL: The URL to the artwork if already known
     - Returns: A `ResultsModel` containing the response from the API
     */
    private func makeRequest(
        with endpoint: Endpoint,
        title: String? = nil,
        artist: String? = nil,
        knownArtworkURL: URL? = nil
    ) async throws -> ResultsModel {
        // Get response asynchronously from API
        let response = try await network.request(from: endpoint)
        
        // Get artwork URL and names
        var artworkURL = Network.getArtworkURL(from: response)
        var (artistName, mediaTitle) = Network.getSongNameAndArtist(from: response)
        
        // If we have been given title, artist or URl then override
        if let title = title {
            mediaTitle = title
        }
        if let artist = artist {
            artistName = artist
        }
        if let url = knownArtworkURL {
            artworkURL = url
        }
        
        // Set origin entity ID
        self.originEntityID = response.entityUniqueId
        
        // Fix Dictionaries
        let platformLinks = network.fixDictionaries(response: response)
        
        // Set the result
        return ResultsModel(
            artworkURL: artworkURL,
            mediaTitle: mediaTitle ?? "",
            artistName: artistName ?? "",
            response: platformLinks
        )
    }
    
    
    // MARK: Shazam
    
    /// Declares what stage the shazam search is in
    enum ShazamState: Equatable {
        /// Nothing is happening
        case idle
        /// The search is in progress
        case matching
        /// A match has been found
        case matchFound
        /// Finished Processing Song.Link API results
        case finished
    }
    
    /// Starts to record from the microphone and send the buffer to shazam for a match
    func startShazamMatch() {
        self.shazamState = .matching
        
        // The delegate will receive callbacks when the media is recognized.
        session.delegate = self
        
        // Create an audio format for our buffers based on the format of the input, with a single channel (mono).
        let audioFormat = AVAudioFormat(
            standardFormatWithSampleRate: audioEngine.inputNode.outputFormat(forBus: 0).sampleRate,
            channels: 1
        )
        
        // Install a "tap" in the audio engine's input so that we can send buffers from the microphone to the session.
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 2048, format: audioFormat) { [weak session] buffer, audioTime in
            // Whenever a new buffer comes in, we send it over to the session for recognition.
            session?.matchStreamingBuffer(buffer, at: audioTime)
        }
        
        // Tell the system that we're about to start recording.
        try? AVAudioSession.sharedInstance().setCategory(.record)
        
        // Ensure that we have permission to record, then start running the audio engine.
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] success in
            guard success, let self = self else { return }
            
            try? self.audioEngine.start()
        }
    }
    
    /// Stops recording and removes the buffer tap
    func stopMatching() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

extension RequestViewModel: SHSessionDelegate {
    /// Match found
    func session(_ session: SHSession, didFind match: SHMatch) {
        print("Match Found")
        
        // Stop recording
        stopMatching()
        
        // Get the matched item
        guard let matchedItem = match.mediaItems.first else {
            return
        }
        
        // Get the apple music URL
        guard let appleMusicURLString = matchedItem.appleMusicURL?.absoluteString else {
            return
        }
        
        // Set the button status
        DispatchQueue.main.async { self.shazamState = .matchFound }
        
        async {
            await getResults(for: appleMusicURLString, with: userSettingsSnapshot, title: matchedItem.title, artist: matchedItem.artist, artworkURL: matchedItem.artworkURL)
            self.shazamState = .finished
        }
    }
    
    /// No match found or error occured
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        // Check if error occured
        if let error = error {
            self.errorDescription = ("Something went wrong.", error.localizedDescription)
        // No match found
        } else {
            self.errorDescription = ("No Match Found", "Shazam could not find a match from the audio. Please try again")
        }
    }
}
