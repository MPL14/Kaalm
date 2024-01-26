//
//  CGRect-Extensions.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import UIKit

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(minX)
        hasher.combine(minY)
        hasher.combine(maxX)
        hasher.combine(maxY)
    }
}
