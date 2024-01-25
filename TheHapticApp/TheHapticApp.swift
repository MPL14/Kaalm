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

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(hapticEffects)
        }
    }
}
