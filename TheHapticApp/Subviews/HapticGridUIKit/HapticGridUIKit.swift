//
//  HapticGridUIKit.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 2/14/24.
//

import SwiftUI

struct HapticGridUIKit<H: HapticPlaying>: View {
    @EnvironmentObject private var hapticEngine: H

    private var size: CGSize = .init(width: 0.5, height: 0.5)

    var body: some View {
        HapticGridUIView<HapticEngine>(frame: size)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Haptic Dot Grid")
            .accessibilityHint("Plays haptics as you touch and drag.")
            .accessibilityAddTraits(.allowsDirectInteraction)
            .accessibilityIdentifier("hapticGrid")
    }

    public func size(frame: CGSize) -> HapticGridUIKit {
        var view = self
        view.size = frame
        return view
    }
}
