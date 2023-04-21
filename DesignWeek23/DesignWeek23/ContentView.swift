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
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
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
                self.errorMessage = "Error: \(error.localizedDescription)"
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
            } else {
                // Handle non-200 status code
                self.errorMessage = "Error: Received non-200 status code: \(response.statusCode)"
            }
        }
        
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
