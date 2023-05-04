//
//  StyleView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 29.04.23.
//

import SwiftUI

struct Style: Identifiable, Equatable {
    let id = UUID()
    let image: String
    let title: String
    let promptStyleText: String
    
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
        VStack {
            Text("Style")
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 400))], spacing: 20) {
                ForEach(styles) { style in
                    Button(action: {
                        selectedStyle = style
                        promtAddition = style.promptStyleText
                    }) {
                        VStack {
                            Image(systemName: style.image)
                                .font(.system(size: 80))
                                .bold()
                                .padding()
                                .foregroundColor(.orange)
                            //                                .overlay(LinearGradient(gradient: Gradient(colors: [.orange, .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            Text(style.title)
                                .padding(7)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style == selectedStyle ? Color.blue : Color.clear, lineWidth: 6)
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct StyleView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}

