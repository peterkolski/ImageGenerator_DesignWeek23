//
//  ScreesaverView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//

import SwiftUI

import SwiftUI

struct ScreensaverView: View {
    var body: some View {
        VStack {
//            // Large title
//            Text("Title")
//                .font(.largeTitle)
//                .bold()
//                .padding(.bottom, 20)

            // Call to action image
            Image("IconLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 1000)

            // Subtext
            Text("Revolutionize your design process with AI")
//                .font(.largeTitle)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding(40)
            
            // CTA
            Text("Touch the iPad to try it out")
                .font(.title)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(30)
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color(red: 18/100, green: 9/100, blue: 85/100),
                                Color(red: 53/100, green: 29/100, blue: 100/100)
                            ]
                        ),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .cornerRadius(100)
                )
                .padding(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
          RadialGradient(
            gradient: Gradient(colors: [
                Color(red: 20.0 / 100, green: 22.0 / 100, blue: 27.0 / 100),
                Color.black

            ]),
            center: .center,
            startRadius: 0,
            endRadius: UIScreen.main.bounds.width / 2
          )
        )
    }
}


struct ScreesaverView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background Full")
            ScreensaverView()
        }
    }
}
