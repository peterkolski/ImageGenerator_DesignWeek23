//
//  StyleView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 29.04.23.
//

import SwiftUI

struct Style: Identifiable, Equatable {
    let id: String // Change the type of id to String
    let image: String
    let title: String
    let promptStyleText: String
    
    init(image: String, title: String, promptStyleText: String) {
        self.id = title // Assign the title as the id
        self.image = image
        self.title = title
        self.promptStyleText = promptStyleText
    }
    
    static func == (lhs: Style, rhs: Style) -> Bool {
        lhs.id == rhs.id
    }
}


struct ParentView: View {
    @StateObject var viewModel = ImageGeneratorModel()
    
    var body: some View {
        StyleView(promtAddition: $viewModel.promtAddition)
    }
}

struct StyleView: View {
    let styles = [
        Style(image: "cube", title: "3D Model", promptStyleText: ", style 3D model"),
        Style(image: "photo", title: "Photographic", promptStyleText: ", style photographic"),
        Style(image: "scribble", title: "Sketch", promptStyleText: ", style sketch"),
        Style(image: "perspective", title: "Isometric", promptStyleText: ", style isometric")
    ]
    
    @State private var selectedStyle: Style?
    @Binding var promtAddition: String
    
    var body: some View {
        let gradient = Gradient(colors: [Color(red: 82/100, green: 13/100, blue: 29/100),
                                         Color(red: 99/100, green: 56/100, blue: 40/100)])
        let linearGradient = LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 400))], spacing: 10) {
            ForEach(styles) { style in
                Button(action: {
                    selectedStyle = style
                    promtAddition = style.promptStyleText
                    print("Style chosen: \(String(describing: selectedStyle?.title))")
                }) {
                    VStack {
                        Image(systemName: style.image)
                            .font(.system(size: 80))
                            .bold()
//                            .foregroundColor(.orange)
                            .overlay(linearGradient.mask(Image(systemName: style.image)
                                .bold()
//                                .resizable()
//                                .scaledToFit()
                                .font(.system(size: 80))))
                        
                        HStack { // Add an HStack here
                            if style == selectedStyle {
                                Image(systemName: "checkmark.square") // Display a checkmark box if the style is selected
                                    .foregroundColor(.orange)
                            } else {
                                Image(systemName: "square") // Display an empty box if the style is not selected
                                    .foregroundColor(.white)
                            }
                            
                            Text(style.title)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .cornerRadius(10)
                    //                    .overlay(
                    //                        RoundedRectangle(cornerRadius: 10)
                    //                            .stroke(style == selectedStyle ? Color.blue : Color.clear, lineWidth: 6)
                    //                    )
                }
            }
        }
    }
}

struct StyleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            HStack {
                ParentView()
                Spacer()
                ParentView()
            }
        }
    }
}

