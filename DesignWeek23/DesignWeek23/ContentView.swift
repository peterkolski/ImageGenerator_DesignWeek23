import SwiftUI

struct ContentView: View {
    @State private var isFullScreen = false
    @StateObject var viewModel = ImageGeneratorModel()
    
    var body: some View {
            ZStack{
                if isFullScreen{
                    Color.black
                        .opacity(isFullScreen ? 1 : 0)
                        .edgesIgnoringSafeArea(.all)
                        .animation(.easeInOut(duration: 0.3))
                }
                
                GeometryReader { geometry in
                    HStack {
                        VStack{
                            if !isFullScreen{
                                // Text input field
                                TextField("Enter text", text: $viewModel.text)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1) // Add a gray border
                                    )
                                
                                // Display any error message
                                if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                                
                                // Button to generate the image
                                Button("Generate image") {
                                    viewModel.generateImage { result in
                                        switch result {
                                        case .success(let image):
                                            viewModel.image = image
                                            viewModel.errorMessage = nil
                                        case .failure(let error):
                                            viewModel.image = nil
                                            viewModel.errorMessage = error.localizedDescription
                                        }
                                    }
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1) // Add a gray border
                                )
                            }
                        }
                        VStack{
                            // Display the generated image
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: isFullScreen ? geometry.size.width : geometry.size.width * 0.5,
                                           height: isFullScreen ? geometry.size.height : geometry.size.height * 0.5)
                                //                            .background(Color.black)
                                    .cornerRadius(isFullScreen ? 0 : 10)
                                    .gesture(TapGesture().onEnded {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isFullScreen.toggle()
                                        }
                                    })
                                    .edgesIgnoringSafeArea(isFullScreen ? .all : [])
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1) // Add a gray border
                                    )
                            }
                            Text("Last Text: ")
                        }
                    }
            }
        }
    }
}


// ------------------

class ImageGeneratorModel: ObservableObject {
    @Published var text = ""
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

// -----------------

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
