//
//  IntentHandler.swift
//  SongLinkr
//
//  Created by Harry Day on 10/06/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        switch intent {
            case is MatchURLToPlatformIntent:
                return MatchURLToPlatformHandler()
            default:
                // No intents should be unhandled so we’ll throw an error by default
                fatalError("No handler for this intent")
        }
    }
    
}
