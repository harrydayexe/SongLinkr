//
//  GetLinkButton.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import Foundation
import SwiftUI

struct GetLinkButton: View {
    @Binding var callInProgress: Bool
    @Binding var searchURL: String
    @Binding var showResults: Bool
    @Binding var response: [PlatformLinks]
    @State var showError: Bool = false
    @State var errorDescription: (String, String) = ("","")
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Button(action: {
            if self.searchURL != "" {
                self.callInProgress = true
                
                Network.request(.search(with: Network.encodeURL(from: self.searchURL))) { (result) in
                    switch result {
                        case .success(let data):
                            do {
                                let decodedResponse = try JSONDecoder().decode(SongLinkAPIResponse.self, from: data)
                                self.response = Network.fixDictionaries(response: decodedResponse).sorted(by: { $0.id.rawValue < $1.id.rawValue })
                                print(self.response)
                                
//                                Auto Open if turned on
                                if userSettings.autoOpen {
                                    if let defaultPlatformIndex = response.firstIndex(where: { $0.id == userSettings.defaultPlatform }) {
                                        let defaultPlatform = response[defaultPlatformIndex]
                                        DispatchQueue.main.async {
                                            UIApplication.shared.open(defaultPlatform.nativeAppUriMobile ?? defaultPlatform.url)
                                        }
                                    }
                                }
                                
                                self.callInProgress = false
                                self.showResults = true
                            } catch {
                                self.showResults = false
                                self.callInProgress = false
                                
                                self.errorDescription = Network.createErrorMessage(from: Network.DataLoaderError.decodingError(error))
                                
                                self.showError = true
                            }
                        case .failure(let dataLoaderError):
                            self.showResults = false
                            self.callInProgress = false
                            print(dataLoaderError)
                            self.errorDescription = Network.createErrorMessage(from: dataLoaderError)
                            
                            self.showError = true
                    }
                }
            }
        }) {
            GetLinkButtonView(callInProgress: self.$callInProgress)
        }
        .alert(isPresented: self.$showError) {
            Alert(title: Text(self.errorDescription.0), message: Text(self.errorDescription.1), dismissButton: .cancel())
        }
        .buttonStyle(GetLinkButtonStyle())
        .padding()
        .disabled(self.searchURL == "")
    }
}

struct GetLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        GetLinkButton(callInProgress: .mock(false), searchURL: .constant("https://youtu.be/9XvXLrWgA"), showResults: .mock(false), response: .constant([]))
            .environmentObject(UserSettings())
    }
}
