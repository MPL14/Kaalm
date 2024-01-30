//
//  GridPoint.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import Foundation

struct GridPoint: Hashable, Equatable {
    let x: Int
    let y: Int

    // Equatable conformance.
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        // Compare the x and y indices for the lhs and rhs.
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
