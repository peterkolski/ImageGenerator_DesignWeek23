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
            // Large title
            Text("Title")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            // Call to action image
            Image(systemName: "arrow.forward")
                .font(.system(size: 80))
                .padding(.bottom, 20)

            // Subtext
            Text("Subtext")
                .font(.body)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial) // Blurred background
    }
}


struct ScreesaverView_Previews: PreviewProvider {
    static var previews: some View {
        ScreensaverView()
    }
}
