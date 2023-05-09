//
//  ContentViewTests.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//
import SwiftUI
import UIKit

class FolderManager: ObservableObject {
    @Published var folderURL: URL? = nil
}

struct FolderPicker: UIViewControllerRepresentable {
    @ObservedObject var folderManager: FolderManager
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FolderPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FolderPicker>) {
        // Nothing to update
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FolderPicker
        
        init(_ parent: FolderPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.folderManager.folderURL = urls.first
        }
    }
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
