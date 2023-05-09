//
//  OutputColumn.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 08.05.23.
//

import SwiftUI

struct OutputColumn: View {
    @Binding var isFullScreen: Bool
    @ObservedObject var viewModel: ImageGeneratorModel
    
    var body: some View {
        VStack {
            if !isFullScreen {
                Text("Click for full screen")
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            GeneratedImageView(isFullScreen: $isFullScreen, viewModel: viewModel)
            
            if !isFullScreen {
                LastTextSection(viewModel: viewModel)
            }
        }
    }
}

struct GeneratedImageView: View {
    @Binding var isFullScreen: Bool
    @ObservedObject var viewModel: ImageGeneratorModel
    
    var body: some View {
        GeometryReader { geometry in
            if let lastText = viewModel.lastText, let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isFullScreen ? geometry.size.width : geometry.size.width * 0.5,
                           height: isFullScreen ? geometry.size.height : geometry.size.height * 0.5)
                    .cornerRadius(isFullScreen ? 0 : 10)
                    .shadow(color: .black, radius: 5, x: 5, y: 5)
                    .gesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFullScreen.toggle()
                        }
                    })
                    .edgesIgnoringSafeArea(isFullScreen ? .all : [])
            } else {
                Image("SampleImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isFullScreen ? geometry.size.width : geometry.size.width * 0.5,
                           height: isFullScreen ? geometry.size.height : geometry.size.height * 0.5)
                    .foregroundColor(.white)
                    .gesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFullScreen.toggle()
                        }
                    })
                    .edgesIgnoringSafeArea(isFullScreen ? .all : [])
            }
        }
    }
}

struct LastTextSection: View {
    @ObservedObject var viewModel: ImageGeneratorModel
    
    var body: some View {
        if let lastText = viewModel.lastText {
            Group {
                Text("Last Text: \n\(lastText)")
            }
            .modifier(MyTextFieldStyle())
        } else {
            Text("No Text Entered yet")
                .modifier(MyTextFieldStyle())
        }
    }
}


struct OutputColumn_Previews: PreviewProvider {
    @StateObject var viewModel = ImageGeneratorModel()
    static var previews: some View {
        ZStack{
            Color.gray
            OutputColumn(isFullScreen: .constant(false), viewModel: ImageGeneratorModel())
        }
    }
}
