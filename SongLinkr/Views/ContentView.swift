//
//  ContentView.swift
//  SongLinkr
//
//  Created by Harry Day on 26/06/2020.
//

import SwiftUI

struct ContentView: View {
    @State var callInProgress: Bool = false
    @State var searchURL: String = ""
    @State var showResults: Bool = false
    @State var response: [PlatformLinks] = []
    @State var showError: Bool = false
    @State var errorDescription: (String, String) = ("", "")
    
    var body: some View {
        ZStack {
            Color("AppBlue")
                .edgesIgnoringSafeArea(.all)
            VStack {
                MainTextView(searchURL: self.$searchURL)
                Button(action: {
                    self.callInProgress = true
                    
                    Network.request(.search(with: Network.encodeURL(from: self.searchURL))) { (result) in
                        switch result {
                            case .success(let data):
                                do {
                                    let decodedResponse = try JSONDecoder().decode(SongLinkAPIResponse.self, from: data)
                                    self.response = Network.fixDictionaries(response: decodedResponse)
                                    
                                    self.callInProgress = false
                                    self.showResults = true
                                } catch {
                                    self.showResults = false
                                    self.callInProgress = false
                                    
                                    self.errorDescription = Network.createErrorMessage(from: Network.DataLoaderError.decodingError(error))
                                    
                                    self.showError = true
//                                    TODO: Error alert here
                                }
                            case .failure(let dataLoaderError):
                                self.showResults = false
                                self.callInProgress = false
                                
                                self.errorDescription = Network.createErrorMessage(from: dataLoaderError)
                                
                                self.showError = true
//                                TODO: Error alert here
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
        .sheet(isPresented: self.$showResults) {
            ResultsView(showResults: self.$showResults, response: self.response)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
