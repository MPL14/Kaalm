//
//  View-Extensions.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 3/22/24.
//

import Foundation
import SwiftUI

extension View {
    func toolbarTitle(_ title: Text, color: Color = Color.primary) -> some View {
        self.modifier(ToolbarTitleModifier(title: title, color: color))
    }
}

struct ToolbarTitleModifier: ViewModifier {
    let title: Text
    let color: Color

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    title
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                }
            }
    }
}
