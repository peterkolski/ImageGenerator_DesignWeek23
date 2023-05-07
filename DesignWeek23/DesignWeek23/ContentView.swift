import SwiftUI

struct ContentView: View {
    @State private var isFullScreen = false
    @State private var showOnboarding = false
    @StateObject var viewModel = ImageGeneratorModel()
    private var folderName : String = "DesignWeekAppOutput"
    @StateObject private var screensaverTimer = ScreensaverTimer(interval: 4) {
        print("Screensaver timeout")
    }
    @State private var showScreensaver = false
    
    var body: some View {
        ZStack{
            Color(red: 45/255, green: 48/255, blue: 58/255)
                .edgesIgnoringSafeArea(.all)
                
            if isFullScreen{
                Color.black
                    .opacity(isFullScreen ? 1 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFullScreen = true
                        }
                    }
                    .onDisappear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFullScreen = false
                        }
                    }
            }
            
            GeometryReader { geometry in
                HStack {
                    VStack{
                        VStack {
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        showOnboarding = true
                                    }
                                }) {
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        if !isFullScreen{
                            // Text input field
                            TextField("Enter text", text: $viewModel.text)
                                .modifier(MyTextFieldStyle())
                                
                            
                            // Display any error message
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                            StyleView(promtAddition: $viewModel.promtAddition)
                            
                            Spacer()
                            // Button to generate the image
                            Button("Generate image") {
                                viewModel.generateImage(folderName: folderName) { result in
                                    switch result {
                                    case .success(let image):
                                        DispatchQueue.main.async {
                                            viewModel.image = image
                                            viewModel.errorMessage = nil
                                        }
                                    case .failure(let error):
                                        DispatchQueue.main.async {
                                            viewModel.image = nil
                                            viewModel.errorMessage = error.localizedDescription
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.pink]), startPoint: .leading, endPoint: .trailing) )
                            .foregroundColor(.white)
                            .bold()
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .black, radius: 5, x: 5, y: 5)
                        }
                    }
                    VStack{
                        if let lastText = viewModel.lastText{
                            // Display the generated image
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: isFullScreen ? geometry.size.width : geometry.size.width * 0.5,
                                           height: isFullScreen ? geometry.size.height : geometry.size.height * 0.5)
                                //                            .background(Color.black)
                                    .cornerRadius(isFullScreen ? 0 : 10)
                                    .shadow(color: .black, radius: 5, x: 5, y: 5)
                                    .gesture(TapGesture().onEnded {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isFullScreen.toggle()
                                        }
                                    })
                                    .edgesIgnoringSafeArea(isFullScreen ? .all : [])
                            }
                        } else{
                            Image(systemName: "photo.artframe" )
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: isFullScreen ? geometry.size.width : geometry.size.width * 0.5,
                                       height: isFullScreen ? geometry.size.height : geometry.size.height * 0.5)
                                .foregroundColor(.white)
                        
                        }
                        
                        if let lastText = viewModel.lastText{
                            Group{
                                Text("Last Text: ")
                                Text(lastText)
                            }
                            .modifier(MyTextFieldStyle())
                        } else{
                            Text("No Text Entered yet")
                                .modifier(MyTextFieldStyle())
                        }
                        
                    }
                }
            }
            
            // MARK: - Onboarding
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .transition(.opacity)
            }
            
            // MARK: - Loading
            // Gray full-screen overlay when loading
            if viewModel.isLoading {
                Color.gray.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            }
            
            // Loading overlay
            if viewModel.isLoading {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.7))
                    .frame(width: 120, height: 120)
                    .overlay(
                        VStack {
                            ActivityIndicatorView()
                            Text("Generating AI image...")
                                .foregroundColor(.white)
                                .padding(.top, 8)
                        }
                    )
            }
            
            // MARK: - Screensaver
            if showScreensaver {
                ScreensaverView()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            showScreensaver = false
                        }
                        screensaverTimer.resetTimer()
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
        // --- Screensaver timer
        .onReceive(screensaverTimer.$isActive) { isActive in
            withAnimation {
                showScreensaver = isActive
                showOnboarding = true
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .onChange(of: screensaverTimer.interactionsCount) { _ in
            screensaverTimer.resetTimer()
        }
        .onAppear {
            screensaverTimer.resetTimer()
        }
        .simultaneousGesture(TapGesture().onEnded {
            screensaverTimer.userInteraction()
        })
    }
}


// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
