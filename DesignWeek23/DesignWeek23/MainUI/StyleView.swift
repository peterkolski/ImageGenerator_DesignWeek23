//
//  StyleView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 29.04.23.
//

import SwiftUI

struct Style: Identifiable, Equatable {
    let id = UUID()
    let symbolName: String
    let text: String
    
    static func == (lhs: Style, rhs: Style) -> Bool {
        lhs.id == rhs.id
    }
}

struct StyleView: View {
    let styles = [
        Style(symbolName: "cube", text: "3D Model"),
        Style(symbolName: "photo", text: "Photographic"),
        Style(symbolName: "scribble", text: "Sketch"),
        Style(symbolName: "perspective", text: "Isometric")
    ]
    
    @State private var selectedStyle: Style?
    
    var body: some View {
        VStack {
            Text("Style")
                .font(.largeTitle)
                .padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 200))], spacing: 20) {
                ForEach(styles) { style in
                    Button(action: {
                        selectedStyle = style
                    }) {
                        VStack {
                            Image(systemName: style.symbolName)
                                .font(.system(size: 40))
                                .padding()
                            
                            Text(style.text)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style == selectedStyle ? Color.blue : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

struct StyleView_Previews: PreviewProvider {
    static var previews: some View {
        StyleView()
    }
}

