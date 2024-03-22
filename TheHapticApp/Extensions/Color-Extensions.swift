//
//  Color-Extensions.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

extension Color {
    /// Initialize a random Color.
    static var random: Color {
        return .init(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

extension UIColor {
    /// Initialize a random pastel UIColor.
    static var randomPastel: UIColor {
        return .init(hue: .random(in: 0...1.0),
                     saturation: 0.3,
                     brightness: 0.8,
                     alpha: 1.0)
    }
}
