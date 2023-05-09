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



// Usage in SwiftUI
struct ContentViewTests: View {
    @StateObject var folderManager = FolderManager()
    @State private var showPicker = false
    
    var body: some View {
        Group {
            if folderManager.folderURL != nil {
                Text("Folder: \(folderManager.folderURL!.path)")
            } else {
                Button("Select Folder") {
                    showPicker = true
                }
                .sheet(isPresented: $showPicker) {
                    FolderPicker(folderManager: folderManager)
                }
            }
        }
    }
}

struct ContentViewTests_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewTests()
    }
}
