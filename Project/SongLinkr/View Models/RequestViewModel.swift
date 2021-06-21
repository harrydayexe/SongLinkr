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
    /// Singleton Instance
    static var shared: RequestViewModel = RequestViewModel()
    
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
    
    /// Cache for last matched shazam item
    private var shazamItemCache: SHMediaItem?
    
    
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
        network: Network = .shared,
        session: SHSession = SHSession(),
        audioEngine: AVAudioEngine = AVAudioEngine()
    ) {
        self.network = network
        self.session = session
        self.audioEngine = audioEngine
    }
    
    // MARK: Error Enum
    /// A struct representing an error that has occured during a request
    struct RequestError: Error {
        enum Code {
            case network(Network.DataLoaderError)
            case shazam(SHError)
            case missingInformation
            case cacheEmpty
            case unknown(Error)
        }
        
        /// Which type of error has occured
        var code: Code
        
        /// Retrieve the localized description for this error.
        var localizedDescription: String {
            switch code {
                case .network(let error):
                    let (_, message) = Network.shared.createErrorMessage(from: error)
                    return message
                    
                case .shazam(let error):
                    return error.localizedDescription
                    
                case .missingInformation:
                    return "The song was matched by Shazam but not enough information was returned. Please try again later."
                    
                case .cacheEmpty:
                    return "The media cache was empty so the song was not saved. Please try again later"
                    
                case .unknown(let error):
                    return error.localizedDescription
            }
        }
        
        /// Retrieve the localized title for this error
        var localizedTitle: String {
            switch code {
                case .network(let error):
                    let (title, _) = Network.shared.createErrorMessage(from: error)
                    return title
                    
                case .missingInformation:
                    return "Some information was missing"
                    
                case .cacheEmpty:
                    return "An error occured whilst saving to Shazam Library"
                    
                case .unknown(_):
                    return "An unknown error occured"
                    
                default:
                    return "Something went wrong"
            }
        }
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
        artworkURL: URL? = nil,
        fromShazam: Bool = false
    ) async {
        let endpoint: Endpoint
        
        // Check if searchString is from shazam.com
        if let searchURL = URLComponents(string: searchString), let host = searchURL.host, host.contains("shazam.com") {
            print("here")
            guard let url = await getAppleMusicURL(from: searchURL) else {
                return
            }
            endpoint = generateEndpoint(with: url.absoluteString)
        } else {
            endpoint = generateEndpoint(with: searchString)
        }
        
        
        do {
            // Get response
            var results = try await makeRequest(with: endpoint, title: title, artist: artist, knownArtworkURL: artworkURL, fromShazam: fromShazam)
            
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
                DispatchQueue.main.async { self.errorDescription = self.network.createErrorMessage(from: error as! Network.DataLoaderError) }
            } else {
                DispatchQueue.main.async { self.errorDescription = ("Something went wrong", "Please try again. If the issue persists please send me an email from the settings page") }
            }
        }
    }
    
    /**
     Takes a Shazam.com link and tries to get the associated SHMediaItem. If it can then it returns an Apple Music URL for the associated media
     - Parameter shazamURL: The `URLComponents` with a host of shazam.com
     - Returns: An Apple Music URL
     */
    private func getAppleMusicURL(from shazamURL: URLComponents) async -> URL? {
        assert(shazamURL.host!.contains("shazam.com"), "URL is not from shazam.com")
        
        // Check URL is for a song
        guard shazamURL.path.starts(with: "/track/") else {
            DispatchQueue.main.async { self.errorDescription = ("Invalid Shazam Link", "Please try again with a new link") }
            return nil
        }
        
        // Get the track id without `/track/`
        var trackID = shazamURL.path.dropFirst(7)
        // If the URL includes anything else then remove it
        if let index = trackID.firstIndex(of: "/") {
            trackID.removeSubrange(index...)
        }
        
        do {
            let mediaItem = try await SHMediaItem.fetch(shazamID: String(trackID))
            
            // Get the apple music URL
            guard let appleMusicURL = mediaItem.appleMusicURL else {
                DispatchQueue.main.async { self.errorDescription = ("No Match Found", "Shazam could not find a match from the audio. Please try again") }
                return nil
            }
            return appleMusicURL
        } catch {
            DispatchQueue.main.async { self.errorDescription = ("Could not find the media item from Shazam", error.localizedDescription) }
            return nil
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
        knownArtworkURL: URL? = nil,
        fromShazam: Bool = false
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
        
        // If from shazam then do not set the origin entity
        // Otherwise this will be set as Apple Music
        // This is a problem when the user has Apple Music as default and also has auto open on
        if fromShazam {
            self.originEntityID = ""
        } else {
            // Set origin entity ID
            self.originEntityID = response.entityUniqueId
        }
        
        // Fix Dictionaries
        let platformLinks = network.fixDictionaries(response: response)
        
        // Set the result
        return ResultsModel(
            artworkURL: artworkURL,
            mediaTitle: mediaTitle ?? "",
            artistName: artistName ?? "",
            isFromShazam: fromShazam,
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
    
    /**
     Starts to record from the microphone and send the buffer to shazam for a match
     - Parameter snapshot: The current value of `UserSettings`
     */
    func startShazamMatch(userSettings snapshot: UserSettings?) {
        // Set the snapshot
        self.userSettingsSnapshot = snapshot
        
        // Set the progress
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
    
    /**
     Add the given media item to the user's shazam library
     - Parameter item: The item to add to the shazam library
     */
    private func addToShazamLibrary(item: SHMediaItem) async throws {
        // Save to Shazam Library Asynchronously
        try await SHMediaLibrary.default.add([item])
        print("Added to Library")
    }
    
    func saveCachedItem() async -> Bool {
        // Get the cached item
        guard let cachedItem = shazamItemCache else {
            DispatchQueue.main.async { self.errorDescription = ("Could not save to library", "The media item was not cached correctly and cannot be saved") }
            return false
        }
        
        do {
            try await addToShazamLibrary(item: cachedItem)
            return true
        } catch {
            DispatchQueue.main.async { self.errorDescription = ("Could not save to library", "Something went wrong") }
            return false
        }
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
            DispatchQueue.main.async { self.errorDescription = ("No Match Found", "Shazam could not find a match from the audio. Please try again") }
            return
        }
        
        // Get the apple music URL
        guard let appleMusicURLString = matchedItem.appleMusicURL?.absoluteString else {
            DispatchQueue.main.async { self.errorDescription = ("No Match Found", "Shazam could not find a match from the audio. Please try again") }
            return
        }
        
        // Set the button status and cache item
        DispatchQueue.main.async {
            self.shazamState = .matchFound
            self.shazamItemCache = matchedItem
        }
        
        async {
            // Get results from API
            await getResults(for: appleMusicURLString, with: userSettingsSnapshot, title: matchedItem.title, artist: matchedItem.artist, artworkURL: matchedItem.artworkURL, fromShazam: true)
            // Set finished state
            self.shazamState = .finished
        }
        
        if let settings = userSettingsSnapshot, settings.saveToShazamLibrary {
            // Save to Shazam Library Asynchronously
            async {
                do {
                    try await addToShazamLibrary(item: matchedItem)
                } catch {
                    DispatchQueue.main.async { self.errorDescription = ("Could not save to library", "Something went wrong") }
                    return
                }
            }
        }
    }
    
    /// No match found or error occured
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        stopMatching()
        // Check if error occured
        if let error = error {
            DispatchQueue.main.async { self.errorDescription = ("Something went wrong.", error.localizedDescription) }
        // No match found
        } else {
            DispatchQueue.main.async { self.errorDescription = ("No Match Found", "Shazam could not find a match from the audio. Please try again") }
        }
    }
}
