//
//  TheHapticAppApp.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

@main
struct TheHapticApp: App {
    @StateObject private var hapticEffects: HapticEngine = HapticEngine()
    
    @AppStorage("onboardingComplete") var onboardingComplete: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !onboardingComplete {
                    OnboardingView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .top)
                        ))
                        .environmentObject(hapticEffects)
                } else {
                    MainView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .bottom)
                        ))
                        .environmentObject(hapticEffects)
                }
            }
            .animation(.easeIn, value: self.onboardingComplete)
        }
    }
} 
