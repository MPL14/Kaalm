//
//  TheHapticAppApp.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import RevenueCat
import SwiftUI

@main
struct TheHapticApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var hapticEffects: HapticEngine = HapticEngine()
    
    @AppStorage("onboardingComplete") var onboardingComplete: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !onboardingComplete {
                    OnboardingView()
                        .transition(.opacity)
                        .environmentObject(hapticEffects)
                } else {
                    MainView()
                        .transition(.opacity)
                        .environmentObject(hapticEffects)
                }
            }
            .animation(.easeIn, value: self.onboardingComplete)
        }
    }
} 

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        PurchaseManager.shared.initialize()

        return true
    }
}
