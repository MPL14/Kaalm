//
//  HapticDotPreferenceKey.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import SwiftUI

struct HapticDotPreferenceData: Equatable, Hashable {
    let gridPoint: GridPoint
    let bounds: CGRect

    init(gridPoint: GridPoint, bounds: CGRect) {
        self.gridPoint = gridPoint
        self.bounds = bounds
    }

    // Equatable conformance.
    static func == (lhs: HapticDotPreferenceData, rhs: HapticDotPreferenceData) -> Bool {
        // Compare the x and y indices and return false if either aren't equal.
        return lhs.gridPoint.x == rhs.gridPoint.x && lhs.gridPoint.y == rhs.gridPoint.y && lhs.bounds == rhs.bounds
    }
}

struct HapticDotPreferenceKey: PreferenceKey {
    typealias Value = Set<HapticDotPreferenceData>

    static var defaultValue: Set<HapticDotPreferenceData> = Set<HapticDotPreferenceData>()

    static func reduce(value: inout Set<HapticDotPreferenceData>, nextValue: () -> Set<HapticDotPreferenceData>) {
        value = value.union(nextValue())
    }
}

extension View {
    func updateHapticDotPreferenceData(_ dotsData: Set<HapticDotPreferenceData>) -> some View {
        preference(key: HapticDotPreferenceKey.self, value: dotsData)
    }
}
