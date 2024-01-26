//
//  NewSwipeToUnlock.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct SwipeToUnlock<H: HapticPlaying>: View, Animatable {
    @EnvironmentObject private var hapticEngine: H

    @State private var colorCircles: [[Bool]] = Array(
        repeating: Array(repeating: true, count: 6) + Array(repeating: false, count: 36),
        count: 7
    )
    @State private var sliderGridSize: CGSize = .zero

    private var gridDim: (Int, Int) = (7, 42)  // (row, column)

    private var dotSize: CGFloat = 6
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = -6

    private var sliderWidth: Int = 6
    @State private var sliderOffset: Int = 0

    var animatableData: Double {
        get { Double(sliderOffset) }
        set { sliderOffset = Int(newValue) }
    }

    var body: some View {
        VStack {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack {
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
                    /// Only allow dragging from right to left.
                    guard dragValue.translation.width > 0 else { return }

                    /// Rubber banding effect for the drag.
                    let dragLimit: CGFloat = CGFloat(gridDim.1 - sliderWidth)
                    print("drag limit: \(dragLimit)")
                    let rubberBanded: CGFloat = RubberBanding.rubberBanding(
                        offset: (dragValue.location.x / sliderGridSize.width) * CGFloat(gridDim.1),
                        distance: (dragValue.location.x / sliderGridSize.width) * CGFloat(gridDim.1),
                        coefficient: 4.5
                    )

                    self.sliderOffset = Int(min(rubberBanded, dragLimit))

                    hapticEngine.playHaptic(.swipeSuccess)
                }
                .onEnded { _ in
                    if self.sliderOffset < gridDim.1 - sliderWidth {
                        let animationDuration = 0.01
                        for i in stride(from: 0, to: self.sliderOffset, by: 1) {
                            withAnimation(.linear(duration: animationDuration).delay(animationDuration * Double(i))) {
                                self.sliderOffset -= 1
                            }
                        }
                    }
                }
        )
    }
}

#Preview {
    SwipeToUnlock<HapticEngine>()
        .environmentObject(HapticEngine())
}
