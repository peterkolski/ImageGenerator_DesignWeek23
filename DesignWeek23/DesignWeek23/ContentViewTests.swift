//
//  ContentViewTests.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//
import SwiftUI

class FolderManager: ObservableObject {
    @Published var folderURL: URL? = nil
}

struct ContentViewTests: View {
    @State private var selectedFolderURL: URL?
    @State private var showPicker = false

    var body: some View {
        VStack {
            if let url = selectedFolderURL {
                Text("Selected folder: \(url.absoluteString)")
            } else {
                Button("Select Folder") {
                    showPicker = true
                }
                .sheet(isPresented: $showPicker, content: {
                    FolderPicker(selectedFolderURL: $selectedFolderURL)
                })
            }
        }
    }
}


//// Usage in SwiftUI
//struct ContentViewTests2: View {
//    @StateObject var folderManager = FolderManager()
//    @State private var showPicker = false
//
//    var body: some View {
//        Group {
//            if folderManager.folderURL != nil {
//                Text("Folder: \(folderManager.folderURL!.path)")
//            } else {
//                Button("Select Folder") {
//                    showPicker = true
//                }
//                .sheet(isPresented: $showPicker) {
//                    FolderPicker(folderManager: folderManager)
//                }
//            }
//        }
//    }
//}

struct ContentViewTests_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewTests()
    }
}
