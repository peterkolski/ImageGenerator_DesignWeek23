//
//  FolderPicker.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 09.05.23.
//

import SwiftUI
import UIKit

struct FolderPicker: UIViewControllerRepresentable {
    @Binding var selectedFolderURL: URL?
    
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
            parent.selectedFolderURL = urls.first
        }
    }
}
