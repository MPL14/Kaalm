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
    // The Settings view has sliders which update AppStorage values
    // which obviously are also used here. Updating them causes the
    // settingsViewModel to be reinitialized a ton. Initializing it here
    // then passing it to SettingsView below solves this issue.
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()

    @AppStorage(Constants.gridRows) var currentGridRows: Double = Constants.defaultGridSize
    @AppStorage(Constants.gridCols) var currentGridCols: Double = Constants.defaultGridSize
    @AppStorage(Constants.dotSize) var currentDotSize: Double = Constants.defaultDotSize
    @AppStorage(Constants.myColor) var myColor: String = Constants.defaultColor
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.feedbackSharpness) var feedbackSharpness: Double = 1.0

    var body: some View {
        NavigationStack {
            VStack {
                HapticGrid<HapticEngine>()
                    .gridDimensions(Int(currentGridRows), Int(currentGridCols))
                    .dotSize(CGFloat(currentDotSize))
                    .dotPadding(3)
                    .dotColor(Color(myColor))
                    .feedback(feedbackIntensity, feedbackSharpness)
            }
            .padding()
            .toolbar {
                toolbarView
            }
        }
        .foregroundStyle(Color(Constants.defaultColor))
        .tint(Color(Constants.defaultColor))
        .environmentObject(hapticEngine)
    }

    // MARK: - Subviews
    private var toolbarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                TitleView()
                    .accessibilityAddTraits(.isHeader)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(settingsViewModel)
                } label: {
                    Image(systemName: "person.circle")
                        .font(.system(size: 24, weight: .semibold))
                }
                .accessibilityLabel("Personalization Settings")
                .accessibilityIdentifier("personalizationSettings")
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(HapticEngine())
}
