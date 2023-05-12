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
        OnboardingPage(image: "infinity.circle",
                       title: "What?",
                       subtext:
"""
You can create yourself images
This is not a production tool
Input text
"""),
        OnboardingPage(image: "cpu",
                       title: "How?",
                       subtext: """
"""),
        OnboardingPage(image: "wand.and.rays.inverse",
                       title: "Call to Thinking",
                       subtext: """
"""),
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
                
                OnboardingTextView(page: pages[currentPageIndex])
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
                        let gradient = Gradient(colors: [Color(red: 19/100, green: 9/100, blue: 84/100),
                                                         Color(red: 54/100, green: 34/100, blue: 96/100)])
                        let linearGradient = LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
                        
                        Text(currentPageIndex + 1 < pages.count ? "Next" : "Close")
                            .font(.title)
            //                .font(.system(size: 50))
                            .bold()
                            .foregroundColor(.white)
                            .padding(20)
                            .padding([.leading, .trailing], 50)
                            .background(linearGradient)
                            .cornerRadius(60)
                    }
                    .padding()
                
                Spacer()
                
                Text("\(currentPageIndex + 1)/\(pages.count)")
                .foregroundColor(Color.red)
                    .font(.system(size: 25))
                    .bold()
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
