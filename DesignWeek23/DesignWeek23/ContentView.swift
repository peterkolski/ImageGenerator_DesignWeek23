import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var image: UIImage?
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $inputText)
                .padding()
            
            Button(action: {
                // Send the input text to the API and update the image
                self.sendInputToAPI()
            }) {
                Text("Submit")
            }
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
    }
    
    func sendInputToAPI() {
        guard let url = URL(string: "https://platform.stability.ai/v1/models/pix2pix/predict") else {
            // handle invalid URL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["input": inputText]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle the error
                let message = self.messageForErrorCode(error._code)
                self.errorMessage = "Error: \(message)"
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle invalid response
                self.errorMessage = "Error: Invalid response"
                return
            }
            
            guard let data = data else {
                // Handle missing data
                self.errorMessage = "Error: Missing data"
                return
            }
            
            if response.statusCode == 200 {
                // Parse the image from the response data
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Update the image in the UI
                        self.image = image
                    }
                }
                
                // Clear any previous error messages
                self.errorMessage = ""
            } else {
                // Handle non-200 status code
                let message = self.messageForErrorCode(response.statusCode)
                self.errorMessage = "Error: \(message)"
            }
        }
        
        task.resume()
    }
    
    func messageForErrorCode(_ errorCode: Int) -> String {
        switch errorCode {
        case -1001:
            return "The request timed out"
        case -1003:
            return "A URL is malformed"
        case -1004:
            return "The resource could not be found"
        case -1005:
            return "The network connection was lost"
        case -1009:
            return "The internet connection is offline"
        case -1010:
            return "The request was not allowed"
        case -1011:
            return "The server encountered an error"
        case -1012:
            return "The user cancelled the request"
        case -1013:
            return "The request was too large"
        case -1014:
            return "The server requires authentication"
        case -1015:
            return "The server requires a secure connection"
        case -1100..<0:
            return "An unknown networking error occurred"
        case 400:
            return "The request was malformed or invalid"
        case 401:
            return "Authentication failed or user not authorized"
        case 403:
            return "The user is not allowed to access the resource"
        case 404:
            return "The requested resource was not found"
        case 405:
            return "The method is not allowed for the resource"
        case 500:
            return "A server error occurred"
        case 503:
            return "The service is unavailable"
        default:
            print("Unknown error code: \(errorCode)")
            return "An unknown error occurred"
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
