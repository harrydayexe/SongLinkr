//
//  TranslationCreditView.swift
//  SongLinkr
//
//  Created by Harry Day on 17/09/2021
//  
//
//  Twitter: https://twitter.com/realharryday
//  Github: https://github.com/harryday123
//


import SwiftUI

struct TranslationCreditView: View {
    var body: some View {
        List {
            Section(header: Text("German", comment: "Header for list of people who provided translations for German localisation")) {
                Text(verbatim: "MatrixZockt")
            }
            
            Section(header: Text("Spanish", comment: "Header for list of people who provided translations for Spanish localisation")) {
                Link(destination: URL(string: "https://youtube.com/channel/UCdlXeiTAfei1vL782OrYCZg")!, label: {
                    Text(verbatim: "Lorilú")
                })
            }
            Section(header: Text("Japanese", comment: "Header for list of people who provided translations for Japanese localisation")) {
                Link(destination: URL(string: "https://twitter.com/katagaki_")!, label: {
                    Text(verbatim: "Justin")
                })
            }
        }
    }
}

struct TranslationCreditView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationCreditView()
    }
}
