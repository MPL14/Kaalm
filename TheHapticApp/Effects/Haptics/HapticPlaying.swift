//
//  HapticPlaying.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import Foundation

protocol HapticPlaying: ObservableObject {
    func playHaptic(_ hapticType: HapticType)
    func asyncPlayHaptic(_ hapticType: HapticType)
    func asyncPlayHaptic(intensity: CGFloat, sharpness: CGFloat)
}
