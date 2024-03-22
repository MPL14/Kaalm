//
//  EnvironmentValues-Extensions.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 3/22/24.
//

import SwiftUI

extension EnvironmentValues {
    /// Are we in an Xcode preview?
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
