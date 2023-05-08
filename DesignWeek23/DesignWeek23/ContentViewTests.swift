//
//  ContentViewTests.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//

import SwiftUI

struct ContentViewTests: View {
    // MARK: - Properties
    @State private var showOnboarding = false

    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Background
            Color.yellow
                .edgesIgnoringSafeArea(.all)

            // MARK: - Button
            Button(action: {
                withAnimation {
                    showOnboarding = true
                }
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }

            // MARK: - Onboarding View
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
