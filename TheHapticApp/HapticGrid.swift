//
//  ContentView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct HapticGrid: View {
    private var gridDim: (Int, Int) = (16, 16)  // (row, column)

    private var dotSize: CGSize = CGSize(width: 8, height: 8)
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = 0

    @State private var touchedCircles: [[Bool]] = Array(
        repeating: Array(
            repeating: false, count: 16
        ), count: 16
    )

    var body: some View {
        VStack {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack {
                    ForEach(0..<gridDim.1, id: \.self) { column in
                        Circle()
                            .fill(touchedCircles[row][column] ? Color.random : Color.black)
                            .frame(width: dotSize.width, height: dotSize.height)  // Dot size
                            .padding(dotPaddingEdges, dotPadding)
//                            .opacity(self.touchedCircles[row][column] ? 0.0 : 1.0)
//                            .animation(.easeOut(duration: 0.5), value: self.touchedCircles[row][column])
                    }
                }
            }
        }
    }

    public func gridDimensions(_ x: Int, _ y: Int) -> HapticGrid {
        var view = self
        view.gridDim = (x, y)
        view.touchedCircles = Array(repeating: Array(repeating: false, count: y), count: x)
        return view
    }

    public func dotSize(_ size: CGSize) -> HapticGrid {
        var view = self
        view.dotSize = size
        return view
    }

    public func dotPadding(_ edges: Edge.Set = .all, 
                           _ length: CGFloat? = nil) -> HapticGrid {
        var view = self
        view.dotPaddingEdges = edges
        view.dotPadding = length ?? 2
        return view
    }
}

#Preview {
    HapticGrid()
        .gridDimensions(15, 15)
        .dotPadding()
        .padding()
}
