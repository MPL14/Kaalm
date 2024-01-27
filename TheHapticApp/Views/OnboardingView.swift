//
//  OnboardingView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: HapticEngine

    // MARK: - State
    @AppStorage("onboardingComplete") var onboardingComplete: Bool = false

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [.black.opacity(0.8), .black],
                center: .topLeading,
                startRadius: 0.2,
                endRadius: UIScreen.main.bounds.height
            )
                .ignoresSafeArea()
            VStack(spacing: 10) {
                TitleView()
                    .foregroundStyle(.white)

                Text("Calm through haptics.")
                    .foregroundStyle(.white)
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 15) {
                    swipeToUnlock

                    swipeToUnlockText
                }
            }
        }
    }

    // MARK: - Subviews
    private var swipeToUnlock: some View {
        SwipeToUnlock<HapticEngine>($onboardingComplete)
            .gridDimensions(6, 45)
            .sliderWidth(6)
            .dotPadding(0.8)
    }

    private var swipeToUnlockText: some View {
        Text("Swipe to Open")
            .font(.headline)
            .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
    }
}


#Preview {
    OnboardingView()
        .environmentObject(HapticEngine())
}
