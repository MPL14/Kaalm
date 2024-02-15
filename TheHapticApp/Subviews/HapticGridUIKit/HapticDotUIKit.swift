//
//  HapticDotUIKit.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 2/14/24.
//

import UIKit

class HapticDotUIKit: UIView {
    // Override pointInside to increase the hittable area of the dots.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
