//
//  ProfileView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("gridRows") var currentGridRows: Double = 16.0
    @AppStorage("gridCols") var currentGridCols: Double = 16.0

    var body: some View {
        List {
            Group {
                Section("Grid Height") {
                    Slider(value: $currentGridRows, in: 3...25)
                }

                Section("Grid Width") {
                    Slider(value: $currentGridCols, in: 3...25)
                }
            }
            .tint(.primary)
        }
    }
}

#Preview {
    ProfileView()
}
