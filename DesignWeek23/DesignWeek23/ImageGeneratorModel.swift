//
//  ImageGeneratorModel.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 29.04.23.
//

import Foundation
import SwiftUI
import UIKit
import CloudKit


class ImageGeneratorModel: ObservableObject {
    @Published var text = ""
    @Published var promtAddition = ""
    @Published var lastText : String? = nil
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    init() {
        checkICloudAvailability()
    }
    
    func checkICloudAvailability() {
        guard FileManager.default.url(forUbiquityContainerIdentifier: nil) != nil else {
            print("ERROR: iCloud Drive is not available.")
            return
        }
        
        print("iCloud Drive is available.")
    }
    
    func generateImage(folderName: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let apiKey = Constants.apiKey else {
            completion(.failure(NSError(domain: "generateImage", code: 0, userInfo: [NSLocalizedDescriptionKey: "API key not set"])))
            return
        }
        
        let urlString = "https://api.stability.ai/v1/generation/\(Constants.engineID)/text-to-image"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "generateImage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "cfg_scale": 7,
            "clip_guidance_preset": "FAST_BLUE",
            "height": Constants.imageHeight,
            "width": Constants.imageWidth,
            "sampler": "K_DPM_2_ANCESTRAL",
            "samples": 1,
            "steps": 20,
            // Warning: Heterogeneous collection literal could only be inferred to '[String : Any]'; add explicit type annotation if this is intentional
            "text_prompts": [
                [
                    "text": text + promtAddition,
                    "weight": 20
                ]
            ]
        ]
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        print("Loading image")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(NSError(domain: "generateImage", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid request parameters"])))
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "generateImage", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                return
            }
            
            DispatchQueue.main.async {
                self.lastText = self.text
                self.text = ""
            }
            
            // Debugging: print raw data
            //            print("Raw data:")
            //            print(data)
            
            // Parse JSON response
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(.failure(NSError(domain: "generateImage", code: 4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])))
                self.isLoading = false
                return
            }
            
            // Extract base64-encoded image data from the JSON response
            guard let artifacts = json["artifacts"] as? [[String: Any]],
                  let imageDataString = artifacts.first?["base64"] as? String,
                  let imageData = Data(base64Encoded: imageDataString) else {
                completion(.failure(NSError(domain: "generateImage", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                self.isLoading = false
                return
            }
            
            // Debugging: print decoded data
            //            print("Decoded data:")
            //            print(imageData)
            
            // Convert to UIImage
            guard let image = UIImage(data: imageData) else {
                completion(.failure(NSError(domain: "generateImage", code: 6, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                self.isLoading = false
                return
            }
            
            // Save lastText and image to iCloud
            if let lastText = self.lastText {
                self.saveToICloud(folderName: folderName, text: lastText, image: image)
            }
            
            DispatchQueue.main.async {
                self.isLoading = false // Add this line after the request is completed
            }
            print("Loading image completed")
            
            completion(.success(image))
        }.resume()
    }
    
    func saveToICloud(folderName: String, text: String, image: UIImage) {
        // Get the URL for the iCloud Drive Documents folder
        guard let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            print("iCloud Drive is not available.")
            return
        }
        
        // Create a folder in the iCloud Drive Documents folder with the specified folder name
        let folderURL = iCloudDocumentsURL.appendingPathComponent(folderName)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating folder in iCloud Drive: \(error)")
            return
        }
        
        // Generate a unique filename with the current date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = dateFormatter.string(from: Date())
        let uniqueID = UUID().uuidString
        let fileName = "\(dateString)-\(uniqueID)"
        
        // Save the text file
        let textFileURL = folderURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        do {
            try text.write(to: textFileURL, atomically: true, encoding: .utf8)
            print("Text file saved to iCloud Drive: \(textFileURL)")
        } catch {
            print("Error saving text file to iCloud Drive: \(error)")
            return
        }
        
        // Save the image file
        let imageFileURL = folderURL.appendingPathComponent(fileName).appendingPathExtension("jpg")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            do {
                try imageData.write(to: imageFileURL)
                print("Image file saved to iCloud Drive: \(imageFileURL)")
            } catch {
                print("Error saving image file to iCloud Drive: \(error)")
                return
            }
        } else {
            print("Error converting UIImage to JPEG data.")
            return
        }
    }
    
}
