//
//  AcivityView.swift
//  SongLinkr
//
//  Created by Harry Day on 16/07/2020.
//

import SwiftUI


/**
 Used to create a share sheet view to be presented
 `ActivityView(activityItems: [NSURL(string: "https://swiftui.gallery")!] as [Any], applicationActivities: nil)`
 - parameters:
    - activityItems: The array of data objects on which to perform the activity. The type of objects in the array is variable and dependent on the data your application manages. For example, the data might consist of one or more string or image objects representing the currently selected content. Instead of actual data objects, the objects in this array can be objects that adopt the UIActivityItemSource protocol, such as UIActivityItemProvider objects. Source and provider objects act as proxies for the corresponding data in situations where you do not want to provide that data until it is needed. Note that you should not reuse an activity view controller object that includes a UIActivityItemProvider object in its activityItems array. This array must not be nil and must contain at least one object.
    - applicationActivities: An array of UIActivity objects representing the custom services that your application supports. This parameter may be nil.
 */
struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}
