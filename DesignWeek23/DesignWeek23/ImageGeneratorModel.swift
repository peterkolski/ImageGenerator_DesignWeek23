//
//  ImageGeneratorModel.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 29.04.23.
//

import Foundation
import SwiftUI

class ImageGeneratorModel: ObservableObject {
    @Published var text = ""
    @Published var lastText = ""
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func generateImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
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
            "text_prompts": [
                [
                    "text": text,
                    "weight": 20
                ]
            ]
        ]
        
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
            
            // Debugging: print raw data
            print("Raw data:")
            print(data)
            
            // Parse JSON response
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(.failure(NSError(domain: "generateImage", code: 4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])))
                return
            }
            
            // Extract base64-encoded image data from the JSON response
            guard let artifacts = json["artifacts"] as? [[String: Any]],
                  let imageDataString = artifacts.first?["base64"] as? String,
                  let imageData = Data(base64Encoded: imageDataString) else {
                completion(.failure(NSError(domain: "generateImage", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                return
            }
            
            // Debugging: print decoded data
            print("Decoded data:")
            print(imageData)
            
            // Convert to UIImage
            guard let image = UIImage(data: imageData) else {
                completion(.failure(NSError(domain: "generateImage", code: 6, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
}
