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
        let apiKey = Constants.apiKey
        let urlString = "https://platform.stability.ai/rest-api/convert-to-image"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        let parameters: [String: Any] = [
            "text": userInput
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

struct Constants {
    static let apiKey = "sk-zUcWdOuTDjZR3gURbarc49AI7YOS5DMNk8b07V9g5v8hkVGl"
}
