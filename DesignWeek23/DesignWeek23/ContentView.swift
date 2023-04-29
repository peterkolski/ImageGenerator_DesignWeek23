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
                            
                            if let lastText = viewModel.lastText{
                                Text("Last Text: ")
                                Text(lastText)
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
