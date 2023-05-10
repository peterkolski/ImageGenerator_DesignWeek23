//
//  ContentViewRefactored.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 08.05.23.
//

import SwiftUI

// MARK: - Main View
struct ContentView: View {
    @State private var isImageFullScreen = false
    @State private var showOnboarding = false
    @State private var showPicker = false
    @StateObject var imageGeneratorModel = ImageGeneratorModel()
    private var folderName: String = "DesignWeekAppOutput"
    @StateObject private var screensaverTimer = ScreensaverTimer(interval: 30) {
        print("Screensaver timeout")
    }
    @State private var showScreensaver = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if isImageFullScreen {
                FullScreenOverlay(isFullScreen: $isImageFullScreen)
            }
            if !isImageFullScreen {
                HeaderComponent(showOnboarding: $showOnboarding)
            }
            VStack {
                
                
                MainContent(isFullScreen: $isImageFullScreen, viewModel: imageGeneratorModel, folderName: folderName)
            }
            
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .transition(.opacity)
            }
            
            if imageGeneratorModel.isLoading {
                LoadingOverlay(isLoading: imageGeneratorModel.isLoading)
            }
            
            if showScreensaver {
                
                ScreensaverView()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            showScreensaver = false
                            imageGeneratorModel.text = ""
                        }
                        screensaverTimer.resetTimer()
                    }
            }
            
            if imageGeneratorModel.folderURL == nil {
                Button("Select Folder") {
                    showPicker = true
                }
                .font(.largeTitle)
                .padding(30)
                .background(Color.red)
                .cornerRadius(40)
                .sheet(isPresented: $showPicker, content: {
                    FolderPicker(selectedFolderURL: $imageGeneratorModel.folderURL)
                })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
        .onReceive(screensaverTimer.$isActive) { isActive in
            withAnimation {
                showScreensaver = true
                showOnboarding = true
                isImageFullScreen = false
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
        .alert(item: $imageGeneratorModel.errorMessage) { identifiableError in
            Alert(title: Text("Ups...\nSomething went wrong"), message: Text(identifiableError.error), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Components

struct BackgroundView: View {
    var body: some View {
        Color("Background Full")
            .edgesIgnoringSafeArea(.all)
        RadialGradient(
          gradient: Gradient(colors: [
            Color(red: 20.0 / 100, green: 22.0 / 100, blue: 27.0 / 100),
            Color.black
          ]),
          center: .center,
          startRadius: 0,
          endRadius: UIScreen.main.bounds.width / 2
        )
        .ignoresSafeArea()
    }
}

struct FullScreenOverlay: View {
    @Binding var isFullScreen: Bool
    
    var body: some View {
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
}



struct HeaderComponent: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("IconLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Spacer()
                Button(action: {
                    withAnimation {
                        showOnboarding = true
                    }
                }) {
                    Image("IconQuestion")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
            }
            .padding([.leading, .trailing], 40)
            //            .padding(10)
        }
    }
}

struct MainContent: View {
    @Binding var isFullScreen: Bool
    @ObservedObject var viewModel: ImageGeneratorModel
    var folderName: String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if !isFullScreen {
                    InputColumn(viewModel: viewModel, folderName: folderName)
                }
                
                OutputColumn(isFullScreen: $isFullScreen, viewModel: viewModel)
            }
        }
    }
}


struct LoadingOverlay: View {
    var isLoading: Bool
    
    var body: some View {
        Group {
            Color.gray.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
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
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
    }
}
