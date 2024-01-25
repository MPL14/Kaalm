//
//  OnboardingView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var animationDone = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(alignment: .center, spacing: 16) {
                Text("Haptic App")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)

            }
            .padding(0)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    animationDone = true
                }
            }
            .opacity(animationDone ? 0 : 1)
        }
    }
}

#Preview {
    SplashScreenView()
}
