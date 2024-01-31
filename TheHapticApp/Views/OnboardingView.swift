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
    @State private var isAnimating: Bool = false

    @AppStorage(Constants.onboardingComplete) private var onboardingComplete: Bool = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            RadialGradient(
                colors: [.black.opacity(0.8), .black],
                center: isAnimating ? .topTrailing : .topLeading,
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

                    swipeToOpenText
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
    }

    // MARK: - Subviews
    private var swipeToUnlock: some View {
        SwipeToUnlock<HapticEngine> {
            withAnimation {
                self.onboardingComplete = true
            }
        }
        .gridDimensions(6, 50)
        .sliderWidth(7)
        .dotPadding(0.4)
    }

    private var swipeToOpenText: some View {
        Text("Swipe to Open")
            .font(.headline)
            .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
    }
}


#Preview {
    OnboardingView()
        .environmentObject(HapticEngine())
}
