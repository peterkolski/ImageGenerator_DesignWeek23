import UIKit
import PlaygroundSupport

struct Constants {
    static let apiKey : String? = "sk-zUcWdOuTDjZR3gURbarc49AI7YOS5DMNk8b07V9g5v8hkVGl"
    static let engineID = "stable-diffusion-512-v2-1"
    static let imageWidth = 512
    static let imageHeight = 512
}

func generateImage(from text: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
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
        "steps": 75,
        "text_prompts": [
            [
                "text": text,
                "weight": 1
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


let text = "A lighthouse on a cliff"

generateImage(from: text) { result in
    switch result {
    case .success(let image):
        // Display image in a UIImageView
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 512, height: 512)

        // Create a view controller and add the image view as a subview
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.view.addSubview(imageView)

        // Show the view controller in the live view
        PlaygroundPage.current.liveView = vc
    case .failure(let error):
        // Handle error
        print("Error generating image: \(error.localizedDescription)")
    }
}

