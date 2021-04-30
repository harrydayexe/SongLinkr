//
//  DefaultPlatformsPickerView.swift
//  SongLinkr
//
//  Created by Harry Day on 19/07/2020.
//

import SwiftUI

struct DefaultPlatformsPickerView: View {
    @Binding var defaultPlatform: Platform
    
    var body: some View {
        Picker(selection: self.$defaultPlatform, label: Text("default-streaming-platform")) {
            ForEach(Platform.allCases, id: \.self) { platform in
                Text(platform.displayName)
            }
        }
    }
}

struct DefaultPlatformsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(Platform.youtube) { DefaultPlatformsPickerView(defaultPlatform: $0)}
    }
}
