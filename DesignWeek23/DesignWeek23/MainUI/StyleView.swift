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

struct StyleView: View {
    let styles = [
        Style(image: "cube", title: "3D Model", promptStyleText: ", style 3D model"),
        Style(image: "photo", title: "Photographic", promptStyleText: ", style photographic"),
        Style(image: "scribble", title: "Sketch", promptStyleText: ", style sketch"),
        Style(image: "perspective", title: "Isometric", promptStyleText: ", style isometric")
    ]
    
    @State private var selectedStyle: Style?
    
    var body: some View {
        VStack {
            Text("Style")
                .font(.largeTitle)
                .padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 400))], spacing: 20) {
                ForEach(styles) { style in
                    Button(action: {
                        selectedStyle = style
                    }) {
                        VStack {
                            Image(systemName: style.image)
                                .font(.system(size: 80))
                                .padding()
                            
                            Text(style.title)
                                .padding(7)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGroupedBackground))
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
        StyleView()
    }
}

