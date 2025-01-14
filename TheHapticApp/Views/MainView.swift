//
//  MainView.swift
//  TheHapticApp
//


import SwiftUI

struct MainView: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: HapticEngine

    // MARK: - State
    // The Settings view has sliders which update AppStorage values
    // which are also used here. Updating them causes the
    // settingsViewModel to be reinitialized a ton. Initializing it here
    // then passing it to SettingsView below solves this issue.
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()

    @AppStorage(Constants.gridRows) var currentGridRows: Double = Constants.defaultGridSize
    @AppStorage(Constants.gridCols) var currentGridCols: Double = Constants.defaultGridSize
    @AppStorage(Constants.dotSize) var currentDotSize: Double = Constants.defaultDotSize
    @AppStorage(Constants.myColor) var myColor: String = Constants.accentColor
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.feedbackSharpness) var feedbackSharpness: Double = 1.0

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geo in
                    HapticGridUIKit<HapticEngine>()
                        .size(frame: geo.size)
                }
            }
            .padding()
            .navigationTitle("The Haptic App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarView
            }
            .toolbarTitle(Text("The Haptic App"), color: Color(myColor))
        }
        .accentColor(Color(myColor))
        .environmentObject(hapticEngine)
    }

    // MARK: - Subviews
    private var toolbarView: some ToolbarContent {
        Group {
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
