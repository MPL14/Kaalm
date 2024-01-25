//
//  ContentView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct HapticGrid<H: HapticPlaying>: View {
    @EnvironmentObject private var hapticEngine: H

    @State private var touchedCircles: [[Bool]] = Array(
        repeating: Array(
            repeating: false, count: 16
        ), count: 16
    )
    @State private var gridSize: CGSize = .zero


    private var gridDim: (Int, Int) = (16, 16)  // (row, column)

    private var dotSize: CGFloat = 10
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = 0

    var body: some View {
        VStack {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack {
                    ForEach(0..<gridDim.1, id: \.self) { column in
                        Circle()
                            .fill(touchedCircles[row][column] ? Color.random : Color.black)
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

                    guard x >= 0, x < gridDim.1, y >= 0, y < gridDim.0 else { return }

                    hapticEngine.playHaptic(.longPressSuccess)

                    withAnimation(.easeOut(duration: 0.5)) {
                        touchedCircles[y][x] = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            touchedCircles[y][x] = false
                        }
                    }
                }
        )
    }

    public func gridDimensions(_ x: Int, _ y: Int) -> HapticGrid {
        var view = self
        view.gridDim = (x, y)
        view.touchedCircles = Array(repeating: Array(repeating: false, count: y), count: x)
        return view
    }

    public func dotSize(_ size: CGFloat) -> HapticGrid {
        var view = self
        view.dotSize = size
        return view
    }

    public func dotPadding(_ edges: Edge.Set = .all,
                           _ length: CGFloat? = nil) -> HapticGrid {
        var view = self
        view.dotPaddingEdges = edges
        view.dotPadding = length ?? 0
        return view
    }

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
