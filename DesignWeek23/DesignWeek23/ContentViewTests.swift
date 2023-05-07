//
//  ContentViewTests.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//

import SwiftUI

struct ContentViewTests: View {
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Button(action: {
                    withAnimation {
                        showOnboarding = true
                    }
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }

                Spacer()
            }

            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .transition(.opacity)
            }
        }
    }
}



struct ContentViewTests_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewTests()
    }
}
