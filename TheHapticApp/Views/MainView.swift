//
//  MainView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct MainView: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: HapticEngine

    // MARK: - State
    @State private var gridRows: CGFloat = 16.0
    @State private var gridCols: CGFloat = 16.0

    @AppStorage("gridRows") var currentGridRows: Double = 16.0
    @AppStorage("gridCols") var currentGridCols: Double = 16.0

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
//                HapticGrid<HapticEngine>()
//                    .gridDimensions(Int(gridRows), Int(gridCols))
                BetterHapticGrid<HapticEngine>()
                    .gridDimensions(Int(currentGridRows), Int(currentGridCols))
                    .dotSize(30)
                    .dotPadding()
            }
            .toolbar {
                toolbarView
            }
        }
        .tint(.primary)
        .environmentObject(hapticEngine)
    }

    // MARK: - Subviews
    private var toolbarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                TitleView()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 24, weight: .semibold))
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
