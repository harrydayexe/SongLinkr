//
//  StatefulPreviewWrapperView.swift
//  SongLinkr
//
//  Created by Harry Day on 16/07/2020.
//

import SwiftUI

/**
 A Wrapper to enable custom types be used as a binding in SwiftUI previews
 `StatefulPreviewWrapper(false) { ContentView(enabled: $0) }`
 */
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

