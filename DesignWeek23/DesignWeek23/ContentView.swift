import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var image: Image? = nil
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $userInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button(action: {
                getImage()
            }) {
                Text("Get Image")
            }
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    func getImage() {
        guard let apiKey = Constants.apiKey else {
            errorMessage = "API key not set"
            return
        }

        let urlString = "https://api.stability.ai/v1/generation/\(Constants.engineID)/text-to-image"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
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
                    "text": userInput,
                    "weight": 1
                ]
            ]
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            errorMessage = "Invalid request parameters"
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                errorMessage = "Error: \(error?.localizedDescription ?? "Unknown error")"
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let image = UIImage(data: data) {
                        self.image = Image(uiImage: image)
                    } else {
                        errorMessage = "Invalid image data"
                    }
                case 400:
                    errorMessage = "Bad request"
                case 401:
                    errorMessage = "Unauthorized"
                case 403:
                    errorMessage = "Forbidden"
                case 404:
                    errorMessage = "Not found"
                case 429:
                    errorMessage = "Too many requests"
                case 500:
                    errorMessage = "Internal server error"
                case 503:
                    errorMessage = "Service unavailable"
                default:
                    errorMessage = "Unknown error (\(httpResponse.statusCode))"
                }
            } else {
                errorMessage = "Invalid server response"
            }
        }.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
