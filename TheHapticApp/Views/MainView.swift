//
//  MainView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var hapticEngine: HapticEngine

    var body: some View {
        HapticGrid<HapticEngine>()
            .gridDimensions(15, 15)
            .environmentObject(hapticEngine)
    }
}

#Preview {
    MainView()
        .environmentObject(HapticEngine())
}
