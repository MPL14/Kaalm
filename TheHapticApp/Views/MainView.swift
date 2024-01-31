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
    @State private var settingsViewModel: SettingsViewModel = SettingsViewModel()

    @AppStorage(Constants.gridRows) var currentGridRows: Double = 16.0
    @AppStorage(Constants.gridCols) var currentGridCols: Double = 16.0
    @AppStorage(Constants.dotSize) var currentDotSize: Double = 10.0
    @AppStorage(Constants.myColor) var myColor: String = "Default"

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                HapticGrid<HapticEngine>()
                    .gridDimensions(Int(currentGridRows), Int(currentGridCols))
                    .dotSize(CGFloat(currentDotSize))
                    .dotPadding()
                    .dotColor(Color(myColor))
            }
            .toolbar {
                toolbarView
            }
        }
        .foregroundStyle(Color("Default"))
        .tint(Color("Default"))
        .environmentObject(hapticEngine)
    }

    // MARK: - Subviews
    private var toolbarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                TitleView()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        HStack {
                            Text("Customize Appearance")
                            Image(systemName: "paintpalette")
                        }
                    }

                    NavigationLink {
                        SettingsView(settingsViewModel)
                    } label: {
                        HStack {
                            Text("Settings")
                            Image(systemName: "gear")
                        }
                    }
                } label: {
                    Image(systemName: "person.circle")
                        .font(.system(size: 24, weight: .semibold))
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(HapticEngine())
}
