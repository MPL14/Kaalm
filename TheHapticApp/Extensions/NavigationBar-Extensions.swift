//
//  NavigationBar-Extensions.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 3/21/24.
//

import SwiftUI

extension View {
    func navigationBarColor(_ color: Color) -> some View {
        self.modifier(NavigationBarColorModifier(color: color))
    }
}

struct NavigationBarColorModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .onAppear {
                let uiColor = UIColor(color)
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
            }
    }
}

