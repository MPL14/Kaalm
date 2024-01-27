//
//  ContentView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct HapticGrid<H: HapticPlaying>: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: H

    // MARK: - State
    // This is super fragile. Currently causes an exception if
    // you use a slider to change the grid dimensions because this
    // doesn't get updated. A better solution to handle the touch
    // color would be to have a dedicated view with a touched Boolean
    // property that changes based on if it was dragged over.
    @State private var touchedCircles: [[Bool]] = Array(
        repeating: Array(
            repeating: false, count: 16
        ), count: 16
    )
    // The size of the grid in the view.
    @State private var gridSize: CGSize = .zero

    // MARK: - Properties
    private var gridDim: (Int, Int) = (16, 16)  // (row, column)

    private var dotSize: CGFloat = 10
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = 0

    private var colorAnimationDuration: CGFloat = 2

    // MARK: - View
    var body: some View {
        VStack {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack {
                    ForEach(0..<gridDim.1, id: \.self) { column in
                        Circle()
                            .fill(touchedCircles[row][column] ? Color.random : .primary)
                            .frame(width: dotSize, height: dotSize)
                            .padding(dotPaddingEdges, dotPadding)
                            .opacity(touchedCircles[row][column] ? 0.0 : 1.0)
                    }
                }
            }
        }
        .background(
            // Use this to get the size of the grid.
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        gridSize = geometry.size
                    }
            }
        )
        .gesture(
            DragGesture(coordinateSpace: .local)
                .onChanged { dragValue in
                    let x = Int((dragValue.location.x / gridSize.width) * CGFloat(gridDim.1))
                    let y = Int((dragValue.location.y / gridSize.height) * CGFloat(gridDim.0))

                    // Only allow gestures which map to an index on the grid.
                    guard x >= 0, x < gridDim.1, y >= 0, y < gridDim.0 else { return }

                    hapticEngine.playHaptic(.swipeSuccess)

                    withAnimation(.easeOut(duration: colorAnimationDuration)) {
                        touchedCircles[y][x] = true
                    }

                    withAnimation(
                        .easeOut(duration: colorAnimationDuration).delay(colorAnimationDuration)
                    ) {
                        touchedCircles[y][x] = false
                    }
                }
        )
    }

    // MARK: - Modifiers
    /// Changes the number of dots on the grid.
    /// - Parameter x: Number of dots on x-axis.
    /// - Parameter y: Number of dots on y-axis.
    public func gridDimensions(_ x: Int, _ y: Int) -> HapticGrid {
        var view = self
        view.gridDim = (x, y)
        view.touchedCircles = Array(repeating: Array(repeating: false, count: y), count: x)
        return view
    }

    /// Changes the dot size.
    /// - Parameter size: Diameter of the dots.
    public func dotSize(_ size: CGFloat) -> HapticGrid {
        var view = self
        view.dotSize = size
        return view
    }

    /// Changes the padding between the dots.
    /// - Parameter edges: Which edges to apply the padding.
    /// - Parameter length: How much padding to apply to the specified edges.
    public func dotPadding(_ edges: Edge.Set = .all,
                           _ length: CGFloat? = nil) -> HapticGrid {
        var view = self
        view.dotPaddingEdges = edges
        view.dotPadding = length ?? 0
        return view
    }

    /// Changes the padding between the dots.
    /// - Parameter length: How much padding to apply to the edges.
    public func dotPadding(_ length: CGFloat? = nil) -> HapticGrid {
        var view = self
        view.dotPaddingEdges = .all
        view.dotPadding = length ?? 0
        return view
    }
}

#Preview {
    HapticGrid<HapticEngine>()
        .gridDimensions(4, 5)
        .dotPadding(.all, 0)
        .dotSize(25)
        .padding()
        .environmentObject(HapticEngine())
}
