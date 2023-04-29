//
//  InfoView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 29.04.23.
//

import SwiftUI

struct InfoContentView: View {
    @State private var showInfoView = false

    var body: some View {
        ZStack {
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showInfoView.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 40))
                            .padding()
                    }
                }
                Spacer()
            }

            if showInfoView {
                InfoView(showInfoView: $showInfoView)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: showInfoView)
            }
        }
    }
}

struct InfoView: View {
    @Binding var showInfoView: Bool

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showInfoView.toggle()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .padding()
                    }
                }

                Spacer()

                Text("Info")
                    .font(.largeTitle)

                Spacer()
            }
        }
        .opacity(showInfoView ? 1 : 0)
    }
}

struct InfoContentView_Previews: PreviewProvider {
    static var previews: some View {
        InfoContentView()
    }
}
