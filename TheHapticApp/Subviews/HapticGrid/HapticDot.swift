//
//  HapticDot.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import SwiftUI

struct HapticDot: View {
    private var color: Color
    private var size: CGFloat

    var body: some View {
        Circle()
            .frame(width: size, height: size)
    }

    init(color: Color = .black, size: CGFloat = 10.0) {
        self.color = color
        self.size = size
    }
}
