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
            Image(systemName: page.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .font(.system(size: 80))
                .bold()
                .foregroundColor(.orange)

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
