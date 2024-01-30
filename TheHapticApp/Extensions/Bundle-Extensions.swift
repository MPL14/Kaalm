//
//  Bundle-Extensioins.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/30/24.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
