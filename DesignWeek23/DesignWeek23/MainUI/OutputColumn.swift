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
            Spacer()
            if !isFullScreen {
                Text("Touch image for full screen")
                    .foregroundColor(Color.white)
//                Spacer()
            }
            
            GeneratedImageView(isFullScreen: $isFullScreen, viewModel: viewModel)
            
            if !isFullScreen {
                LastTextSection(viewModel: viewModel)
            }
            Spacer()
        }
    }
}

struct GeneratedImageView: View {
    @Binding var isFullScreen: Bool
    @ObservedObject var viewModel: ImageGeneratorModel
    
    var image: Image {
        if let uiImage = viewModel.image, let _ = viewModel.lastText {
            return Image(uiImage: uiImage)
        } else {
            return Image("SampleImage")
        }
    }
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(isFullScreen ? 0 : 10)
            .shadow(color: .black, radius: 5, x: 5, y: 5)
            .gesture(TapGesture().onEnded {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFullScreen.toggle()
                }
            })
            .edgesIgnoringSafeArea(isFullScreen ? .all : [])
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
