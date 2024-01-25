//
//  MainView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var hapticEngine: HapticEngine

    @State private var gridRows = 10.0
    @State private var gridCols: Int = 10

    var body: some View {
        NavigationStack {
            VStack {
                HapticGrid<HapticEngine>()
                    .gridDimensions(Int(gridRows), gridCols)

                Slider(value: $gridRows, in: 1...15)
            }
            .toolbar {
                toolbarView
            }
        }
        .environmentObject(hapticEngine)
    }

    private var toolbarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                Text("The Haptic App")
                    .font(.system(.largeTitle, weight: .heavy))
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Go to Settings")
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .heavy))
                        .tint(.primary)
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(HapticEngine())
}
