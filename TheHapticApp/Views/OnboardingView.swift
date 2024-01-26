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
    @State private var onboardingComplete: Bool = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 10) {
                TitleView()
                    .foregroundStyle(.white)

                Text("Calm through haptics.")
                    .foregroundStyle(.white)

//                Text("Onboarding Complete: \(onboardingComplete.description)")
//                    .foregroundStyle(.white)
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 15) {
                    SwipeToUnlock<HapticEngine>($onboardingComplete)

                    swipeToUnlockText
                }
            }
        }
    }

    // MARK: - Subviews
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
