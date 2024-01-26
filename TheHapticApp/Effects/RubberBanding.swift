//
//  RubberBanding.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import Foundation

/// Rubber banding formula from iOS 6.
struct RubberBanding {
    static func rubberBanding(
        offset: CGFloat,
        distance: CGFloat,
        coefficient: CGFloat
    ) -> CGFloat {
        (1.0 - (1.0 / ((offset * coefficient / distance) + 1.0))) * distance
    }
}
