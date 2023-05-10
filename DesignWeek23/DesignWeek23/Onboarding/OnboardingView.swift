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
//        OnboardingPage(image: "brain.head.profile", text: "What?"),
        OnboardingPage(image: "infinity.circle", text: "What?"),
        OnboardingPage(image: "cpu", text: "How?"),
        OnboardingPage(image: "wand.and.rays.inverse", text: "Call to Thinking"),
    ]
    
    var body: some View {
        ZStack {
            // Set the background color
            RadialGradient(
              gradient: Gradient(colors: [
                  Color(red: 20.0 / 100, green: 22.0 / 100, blue: 27.0 / 100),
                  Color.black
              ]),
              center: .center,
              startRadius: 0,
              endRadius: UIScreen.main.bounds.width / 2
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                OnboardingPageView(page: pages[currentPageIndex])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
                
                Spacer()
                
                Text("\(currentPageIndex + 1)/\(pages.count)")
                .foregroundColor(Color.red)
                    .font(.headline)
                    .padding()
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image("Icon close")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
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
