//
//  TheHapticAppApp.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

@main
struct TheHapticApp: App {
    var body: some Scene {
        WindowGroup {
            HapticGrid()
                .gridDimensions(15, 15)
        }
    }
}
