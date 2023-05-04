//
//  ActivityIndicatorView.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 04.05.23.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView

    func makeUIView(context: Context) -> UIViewType {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
