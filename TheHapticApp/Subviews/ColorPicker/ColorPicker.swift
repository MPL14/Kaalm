//
//  ColorPicker.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/29/24.
//

import SwiftUI

/// Custom Color Picker
struct CustomColorPicker<ColorShape: Shape>: View {
    private var title: String
    private var colorShapeSize: CGSize = CGSize(width: 20, height: 20)
    private var colorShape: ColorShape
    private var highlightColor: Color = Color.primary

    @State private var colors: [String] = [String]()
    @Binding private var selectedColor: String

    var body: some View {
        HStack {
            Text("\(title)")

            Spacer()

            ForEach(colors, id: \.hashValue) { color in
                colorShape
                    .fill(Color(color))
                    .frame(width: colorShapeSize.width, height: colorShapeSize.height)
                    .overlay {
                        if selectedColor == color {
                            colorShape
                                .scale(1.3)
                                .stroke(style: .init(lineWidth: 2))
                                .fill(highlightColor)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedColor = color
                        }
                    }
            }
        }
    }

    public init(_ title: String = "Color Picker",
         selectedColor: Binding<String>,
         colorShape: @escaping () -> ColorShape = { Circle() }
    ) {
        self.title = title
        self._selectedColor = selectedColor
        self.colorShape = colorShape()
    }

    /// Changes the color picker's title.
    /// - Parameter newTitle: String
    public func title(_ newTitle: String) -> CustomColorPicker {
        var view = self
        view.title = newTitle
        return view
    }

    /// Changes the selectable colors.
    /// - Parameter colors: An array of Colors to present to the user.
    public func colors(_ colors: [String]) -> CustomColorPicker {
        var view = self
        view._colors = State(initialValue: colors)
        return view
    }

    /// Changes the size of the color swatches.
    /// - Parameter size: CGSize object indicating desired size.
    public func colorShapeSize(_ size: CGSize) -> CustomColorPicker {
        var view = self
        view.colorShapeSize = size
        return view
    }

    /// Changes the color of the selected color highlight.
    /// - Parameter color: A Color.
    public func highlightColor(_ color: Color) -> CustomColorPicker {
        var view = self
        view.highlightColor = color
        return view
    }
}
