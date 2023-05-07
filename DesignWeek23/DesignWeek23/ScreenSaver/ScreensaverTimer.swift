//
//  ScreensaverTimer.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 07.05.23.
//
import Combine
import SwiftUI

class ScreensaverTimer: ObservableObject {
    @Published var isActive = false
    @Published var interactionsCount: Int = 0

    private var timer: Timer?
    private let interval: TimeInterval
    private let onTimeout: () -> Void

    init(interval: TimeInterval, onTimeout: @escaping () -> Void) {
        self.interval = interval
        self.onTimeout = onTimeout
        resetTimer()
    }

    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.onTimeout()
            DispatchQueue.main.async {
                self.isActive = true
            }
        }
    }
    
    func userInteraction() {
        interactionsCount += 1
        resetTimer()
        print("Interaction: \(interactionsCount)")
    }

    deinit {
        timer?.invalidate()
    }
}
