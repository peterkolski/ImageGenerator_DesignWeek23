//
//  TextFieldStyle.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 04.05.23.
//

import SwiftUI

struct WhiteBigTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .font(.largeTitle)
            .bold()
            .padding(20)
    }
}

struct RedTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(red: 99/100, green: 56/100, blue: 40/100))
            .font(.largeTitle)
            .bold()
            .padding(20)
    }
}


struct MyTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.white)
            .padding()
            .background(Color(red: 57/255, green: 57/255, blue: 85/255))
            .cornerRadius(15)
            .shadow(color: .black, radius: 5, x: 5, y: 5)
            .padding(30)
    }
}


struct TextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            Text("Hallo")
                .modifier(MyTextFieldStyle())
            Text("Hallo")
                .modifier(RedTextStyle())
            Text("Hallo")
                .modifier(WhiteBigTextStyle())
        }
        .background(Color.black)
    }
}
