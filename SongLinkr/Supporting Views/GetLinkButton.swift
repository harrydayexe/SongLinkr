//
//  GetLinkButton.swift
//  SongLinkr
//
//  Created by Harry Day on 06/07/2020.
//

import SwiftUI

struct GetLinkButton: View {
    @Binding var callInProgress: Bool
    @Binding var searchURL: String
    @Binding var showResults: Bool
    @Binding var response: [PlatformLinks]
    @State var showError: Bool = false
    @State var errorDescription: (String, String) = ("","")
    
    var body: some View {
        Button(action: {
            self.callInProgress = true
            
            Network.request(.search(with: Network.encodeURL(from: self.searchURL))) { (result) in
                switch result {
                    case .success(let data):
                        do {
                            let decodedResponse = try JSONDecoder().decode(SongLinkAPIResponse.self, from: data)
                            self.response = Network.fixDictionaries(response: decodedResponse).sorted(by: { $0.id.rawValue < $1.id.rawValue })
                            print(self.response)
                            
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
        }) {
            GetLinkButtonView(callInProgress: self.$callInProgress)
        }
        .alert(isPresented: self.$showError) {
            Alert(title: Text(self.errorDescription.0), message: Text(self.errorDescription.1), dismissButton: .cancel())
        }
        .buttonStyle(GetLinkButtonStyle())
        .padding()
    }
}

struct GetLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        GetLinkButton(callInProgress: .mock(false), searchURL: .constant("https://youtu.be/9XvXLrWgA"), showResults: .mock(false), response: .constant([]))
    }
}
