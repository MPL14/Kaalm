//
//  SwipeToUnlock.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct SwipeToUnlock: View {
    @State private var colorCircles: [[Bool]] = Array(
        repeating: Array(repeating: true, count: 6) + Array(repeating: false, count: 44),
        count: 7
    )
    @State private var gridSize: CGSize = .zero

    private var gridDim: (Int, Int) = (7, 50)  // (row, column)

    private var dotSize: CGFloat = 6
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = -6

    private var sliderWidth: Int = 6

    @State private var slideOffset: CGFloat = 0.0

    var body: some View {
        VStack {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack {
                    ForEach(0..<gridDim.1, id: \.self) { column in
                        Circle()
                            .fill(colorCircles[row][column] ? Color.gray : Color.white)
                            .frame(width: dotSize, height: dotSize)
                            .padding(dotPaddingEdges, dotPadding)
                    }
//                    Spacer()
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
        .gesture(DragGesture()
            .onChanged { dragValue in
                let x = Int((dragValue.location.x / gridSize.width) * CGFloat(gridDim.1))

                guard x >= 0, x < gridDim.1 - 6 + 1 else { return }

                colorCircles = Array(
                    repeating:
                        Array(repeating: false, count: x) +
                        Array(repeating: true, count: 6) +
                        Array(repeating: false, count: gridDim.1 - 6 - x),
                    count: 7
                )
            }
        )
    }
}

#Preview {
    SwipeToUnlock()
}
