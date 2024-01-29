//
//  NewSwipeToUnlock.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct SwipeToUnlock<H: HapticPlaying>: View, Animatable {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: H

    // MARK: - State
    // The size of the entire grid within the view.
    @State private var sliderGridSize: CGSize = .zero
    // Manages the offset of the slider within the grid.
    @State private var sliderOffset: Int = 0

//    // Binding to an external variable determining the unlocked status.
//    @Binding private var unlocked: Bool

    // MARK: - Properties
    // Total dimensions of the unlock slider.
    private var gridDim: (Int, Int) = (7, 42)  // (row, column)
    private var sliderWidth: Int = 6

    private var dotSize: CGFloat = 6
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = 1

    private var onUnlock: () -> ()

//    init(_ unlocked: Binding<Bool>) {
//        self._unlocked = unlocked
//    }

    init(_ onUnlock: @escaping () -> ()) {
        self.onUnlock = onUnlock
    }

    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gridDim.1, id: \.self) { column in
                        Circle()
                            .fill(column >= sliderOffset && column < sliderOffset + sliderWidth ? Color.gray : Color.white)
                            .frame(width: dotSize, height: dotSize)
                            .padding(dotPaddingEdges, dotPadding)
                    }
                }
            }
        }
        .background(
            // Use this to get the size of the grid.
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        sliderGridSize = geometry.size
                    }
            }
        )
        .gesture(
            DragGesture()
                .onChanged { dragValue in
                    // Only allow dragging from right to left.
                    guard dragValue.translation.width > 0 else { return }

                    // Rubber banding effect for the drag.
                    let dragLimit: CGFloat = CGFloat(gridDim.1 - sliderWidth)
                    let rubberBanded: CGFloat = RubberBanding.rubberBanding(
                        offset: (dragValue.location.x / sliderGridSize.width) * CGFloat(gridDim.1),
                        distance: (dragValue.location.x / sliderGridSize.width) * CGFloat(gridDim.1),
                        coefficient: 4.5
                    )

                    // Force to only play haptic if the sliderOffset changes.
                    let newSliderOffset = Int(min(rubberBanded, dragLimit))
                    if self.sliderOffset != newSliderOffset {
                        hapticEngine.asyncPlayHaptic(
                            intensity: CGFloat(self.sliderOffset) / CGFloat(gridDim.1 / 2),
                            sharpness: 2
                        )
                        // should make this get stronger as sliderOffset increases
                        self.sliderOffset = newSliderOffset
                    }
                }
                .onEnded { _ in
                    // If gesture didn't complete.
                    if self.sliderOffset < gridDim.1 - sliderWidth {
                        // Hacky way to animate the integer sliderOffset.
                        let animationDuration = 0.009
                        for i in stride(from: 0, to: self.sliderOffset, by: 1) {
                            withAnimation(
                                .linear(duration: animationDuration).delay(animationDuration * Double(i))
                            ) {
                                self.sliderOffset -= 1
                            }
                        }
                    } else {
//                        withAnimation {
//                            self.unlocked = true
//                        }
                        onUnlock()
                    }
                }
        )
    }

    // MARK: - Modifiers
    /// Changes the number of dots on the grid.
    /// - Parameter x: Number of dots on x-axis.
    /// - Parameter y: Number of dots on y-axis.
    public func gridDimensions(_ x: Int, _ y: Int) -> SwipeToUnlock {
        var view = self

        // Reset slider width if needed.
        if view.sliderWidth < y {
            view.sliderWidth = 1
        }

        view.gridDim = (x, y)

        return view
    }

    /// Changes the number of dots on the grid.
    /// - Parameter width: Width of the slider control.
    public func sliderWidth(_ width: Int) -> SwipeToUnlock {
        var view = self

        // Reset slider width if nonzero and smaller
        // than the whole grid's width.
        if width > 0 && width < view.gridDim.1 {
            view.sliderWidth = width
        }

        return view
    }

    /// Changes the dot size.
    /// - Parameter size: Diameter of the dots.
    public func dotSize(_ size: CGFloat) -> SwipeToUnlock {
        var view = self
        view.dotSize = size
        return view
    }

    /// Changes the padding between the dots.
    /// - Parameter edges: Which edges to apply the padding.
    /// - Parameter length: How much padding to apply to the specified edges.
    public func dotPadding(_ edges: Edge.Set = .all,
                           _ length: CGFloat? = nil) -> SwipeToUnlock {
        var view = self
        view.dotPaddingEdges = edges
        view.dotPadding = length ?? 5
        return view
    }

    /// Changes the padding between the dots.
    /// - Parameter length: How much padding to apply to the edges.
    public func dotPadding(_ length: CGFloat? = nil) -> SwipeToUnlock {
        var view = self
        view.dotPaddingEdges = .all
        view.dotPadding = length ?? 5
        return view
    }
}

#Preview {
    SwipeToUnlock<HapticEngine> { }
        .environmentObject(HapticEngine())
}
