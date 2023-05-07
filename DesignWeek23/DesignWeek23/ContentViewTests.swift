//
//  ContentViewTests.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//

import SwiftUI

struct ContentViewTests: View {
    @StateObject private var screensaverTimer = ScreensaverTimer(interval: 2) {
        print("Screensaver timeout")
    }
    @State private var showScreensaver = false

    var body: some View {
        ZStack {
            // Your main content here
            Color.blue
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "scribble.variable")
                .font(.system(size: 80))
                .padding(.bottom, 20)

            if showScreensaver {
                ScreensaverView()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            showScreensaver = false
                        }
                        screensaverTimer.resetTimer()
                    }
            }
        }
        .onReceive(screensaverTimer.$isActive) { isActive in
            withAnimation {
                showScreensaver = isActive
            }
        }
        .onAppear {
            screensaverTimer.resetTimer()
        }
    }
}


struct ContentViewTests_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewTests()
    }
}
