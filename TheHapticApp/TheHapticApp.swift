//
//  TheHapticAppApp.swift
//  TheHapticApp
//
//

import RevenueCat
import SwiftUI

@main
struct TheHapticApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var hapticEffects: HapticEngine = HapticEngine()

    @AppStorage(Constants.onboardingComplete) var onboardingComplete: Bool = false
    @AppStorage(Constants.darkModePreferred) var darkModePreferred: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
              
                    MainView()
               
            }
            .animation(.easeIn, value: self.onboardingComplete)
            .transition(.opacity)
            .preferredColorScheme(darkModePreferred ? .dark : nil)
            .environmentObject(hapticEffects)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
#if DEBUG
            Purchases.logLevel = .debug
#endif
            Purchases.configure(withAPIKey: rcPublicApiKey)

            return true
        }
}
