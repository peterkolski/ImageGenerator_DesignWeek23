//
//  OnboardingView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPageIndex = 0

    let pages = [
        OnboardingPage(image: "hare", text: "What?"),
        OnboardingPage(image: "tortoise", text: "How?"),
        OnboardingPage(image: "questionmark", text: "Call to Thinking"),
    ]

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                OnboardingPageView(page: pages[currentPageIndex])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer()

                HStack {
                    Text("\(currentPageIndex + 1)/\(pages.count)")
                        .font(.headline)
                        .padding()

                    Spacer()

                    Button(action: {
                        if currentPageIndex + 1 < pages.count {
                            currentPageIndex += 1
                        } else {
                            isPresented = false
                        }
                    }) {
                        Text(currentPageIndex + 1 < pages.count ? "Next" : "Close")
                            .bold()
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding()
                }
            }

            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .padding()
                    }
                }

                Spacer()
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true))
    }
}
