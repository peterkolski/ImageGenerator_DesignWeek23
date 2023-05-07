//
//  TextFieldStyle.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 04.05.23.
//

import SwiftUI

struct MyTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .padding()
            .background(Color(red: 57/255, green: 57/255, blue: 85/255))
            .cornerRadius(15)
            .shadow(color: .black, radius: 5, x: 5, y: 5)
            .padding(20)
    }
}


struct TextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hallo")
            .modifier(MyTextFieldStyle())
    }
}
