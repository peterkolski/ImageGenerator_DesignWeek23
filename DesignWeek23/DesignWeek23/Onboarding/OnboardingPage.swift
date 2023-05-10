//
//  OnboardingPage.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//

import SwiftUI

struct OnboardingPage: Identifiable, Equatable {
    var id = UUID()
    let image: String
    let text: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack {
            let gradient = Gradient(colors: [Color(red: 82/100, green: 13/100, blue: 29/100),
                                             Color(red: 99/100, green: 56/100, blue: 40/100)])
            let linearGradient = LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)


            
            Image(systemName: page.image)
                .resizable()
                .scaledToFit()
                .font(.system(size: 80))
                .frame(height: 200)
                .overlay(linearGradient.mask(Image(systemName: page.image)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 80))))
        
            Text(page.text)
                .font(.title)
                .foregroundColor(.white)
                .padding()
        }
    }
}


//struct OnboardingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingPage(image: "hare", text: "What?")
//    }
//}
