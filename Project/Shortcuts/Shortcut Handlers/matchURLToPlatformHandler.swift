//
//  matchURLToPlatformHandler.swift
//  SongLinkr
//
//  Created by Harry Day on 10/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Intents
import SongLinkrNetworkCore
import Combine

/// The Handler for matchURLToPlatform shortcut
class MatchURLToPlatformHandler: NSObject, MatchURLToPlatformIntentHandling {
    
    func resolveUrl(for intent: MatchURLToPlatformIntent, with completion: @escaping (MatchURLToPlatformUrlResolutionResult) -> Void) {
        if let url = intent.url {
            completion(MatchURLToPlatformUrlResolutionResult.success(with: url))
        } else {
            completion(MatchURLToPlatformUrlResolutionResult.unsupported(forReason: .noURL))
        }
    }
    
    func resolveChooseSpecificPlatform(for intent: MatchURLToPlatformIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        let chooseSpecificPlatform = intent.chooseSpecificPlatform?.boolValue ?? false
        completion(INBooleanResolutionResult.success(with: chooseSpecificPlatform))
    }
    
    func resolveTargetPlatform(for intent: MatchURLToPlatformIntent, with completion: @escaping (ShortcutsPlatformsResolutionResult) -> Void) {
        let targetPlatform = intent.targetPlatform
        completion(ShortcutsPlatformsResolutionResult.success(with: targetPlatform))
    }
    
    func handle(intent: MatchURLToPlatformIntent, completion: @escaping (MatchURLToPlatformIntentResponse) -> Void) {
        
        // Unwrap url or throw error
        guard let url = intent.url else {
            completion(MatchURLToPlatformIntentResponse.failure(error: "The entered URL was invalid"))
            return
        }
        // Unwrap bool for if they are picking a specific platform
        let specificPlatformWanted = intent.chooseSpecificPlatform?.boolValue ?? false
        
        // Create percent encoded url string
        let percentEncodedURL = Network.encodeURL(from: url.absoluteString)
        
        // Run network request
        let network = Network()
        network.request(from: .search(with: percentEncodedURL))
            // Map to [PlatformLinks]
            .map { response in
                Network().fixDictionaries(response: response)
            }
            // Get desired platform links arrays
            .map { platformLinks -> [PlatformLinks] in
                // Check if the user wants a specific platform
                if specificPlatformWanted {
                    // Try to find the wanted platform in the list and return
                    if let platformWanted = platformLinks.first(where: { $0.id.shortcutIndex == intent.targetPlatform.rawValue }) {
                        return [platformWanted]
                    // If not found then return nothing
                    } else {
                        return []
                    }
                // If they don't then just return everything
                } else {
                    return platformLinks
                }
            }
            .map { platformLinks in
                return platformLinks.map { $0.url }
            }
            .replaceError(with: [])
            .sink { completion(MatchURLToPlatformIntentResponse.success(result: $0)) }
    }
    
}
