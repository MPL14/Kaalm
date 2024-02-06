//
//  ColorPicker.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/29/24.
//

import SwiftUI

/// Custom Color Picker
struct CustomColorPicker<ColorShape: Shape>: View {
    // MARK: - Environment
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - State
    @State private var colors: [String] = [String]()
    @Binding private var selectedColor: String

    // MARK: - Properties
    private var title: String
    private var colorShapeSize: CGSize = CGSize(width: 20, height: 20)
    private var colorShape: ColorShape
    private var highlightColor: Color = Color.primary
    private let impactLight = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        HStack {
            Text("\(title)")

            Spacer()

            ForEach(colors, id: \.hashValue) { color in
                colorShape
                    .fill(isEnabled ? Color(color) : Color(color).opacity(0.5))
                    .frame(width: colorShapeSize.width, height: colorShapeSize.height)
                    .overlay {
                        if selectedColor == color {
                            colorShape
                                .scale(1.3)
                                .stroke(style: .init(lineWidth: 2))
                                .fill(isEnabled ? highlightColor : highlightColor.opacity(0.5))
                        }
                    }
                    .onTapGesture {
                        selectedColor = color
                        impactLight.impactOccurred()
                    }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Grid Color Picker")
        .accessibilityHint("Change the color of the haptic grid.")
        .accessibilityValue("The grid color is \(selectedColor).")
        .accessibilityAdjustableAction { direction in
            guard let index = colors.firstIndex(where: { $0 == selectedColor }) else { return }

            switch direction {
            case .increment:
                var newIndex = 0
                if index < colors.count - 1 {
                    newIndex = index + 1
                } else {
                    newIndex = 0
                }

                selectedColor = colors[newIndex]
            case .decrement:
                var newIndex = 0
                if index > 0 {
                    newIndex = index - 1
                } else {
                    newIndex = colors.count - 1
                }

                selectedColor = colors[newIndex]
            @unknown default:
                break
            }
        }
    }

    public init(_ title: LocalizedStringResource = "Color Picker",
                selectedColor: Binding<String>,
                colorShape: @escaping () -> ColorShape = { Circle() }
    ) {
        self.title = String(localized: title)
        self._selectedColor = selectedColor
        self.colorShape = colorShape()
    }

    /// Changes the color picker's title.
    /// - Parameter newTitle: String
    public func title(_ newTitle: LocalizedStringResource) -> CustomColorPicker {
        var view = self
        view.title = String(localized: newTitle)
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
