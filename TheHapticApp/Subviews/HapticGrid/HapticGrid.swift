//
//  HapticGrid.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import SwiftUI

struct HapticGrid<H: HapticPlaying>: View {
    @AppStorage("feedbackIntensity") private var feedbackIntensity: Double = 1.0

    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: H

    // MARK: - State
    @State private var touchedGridPoints: Set<GridPoint> = Set<GridPoint>()
    @State private var hapticDotData: Set<HapticDotPreferenceData> = Set<HapticDotPreferenceData>()
    @State private var gridScale: CGSize = .zero

    // MARK: - Properties
    private var gridDim: (Int, Int) = (3, 3)  // (row, column)

    private var dotSize: CGFloat = 25
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = 0

    private var hapticDotColor: Color = .primary
    private var colorAnimationDuration: CGFloat = 0.5

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gridDim.0, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gridDim.1, id: \.self) { column in
                        HapticDot(size: dotSize)
                            .padding(dotPaddingEdges, dotPadding)
                            .foregroundStyle(
                                touchedGridPoints.contains(GridPoint(x: row, y: column)) ? Color.random : hapticDotColor
                            )
                            .opacity(touchedGridPoints.contains(GridPoint(x: row, y: column)) ? 0.5 : 1.0)
                            .background(
                                // Use a geometry reader to get this dot's
                                // location in the view.
                                GeometryReader { dotGeo in
                                    Rectangle()
                                        .fill(.clear)
                                        .updateHapticDotPreferenceData(Set([
                                            HapticDotPreferenceData(
                                                gridPoint: GridPoint(x: row, y: column),
                                                bounds: dotGeo.frame(in: .global)
                                            )
                                        ]))
                                }
                            )
                    }
                }
            }
        }
        .scaleEffect(gridScale, anchor: .center)
        .onAppear {
            withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                gridScale = CGSize(width: 1.0, height: 1.0)
            }
        }
        // This PreferenceKey allows us to monitor the location and index
        // of each HapticDot and do stuff with that information.
        .onPreferenceChange(HapticDotPreferenceKey.self) { value in
            hapticDotData = value
        }
        .gesture(
            // Do the drag gesture in here.
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { dragValue in
                    if let touchedDotData = hapticDotData.first(where: { $0.bounds.contains(dragValue.location) }) {
                        // Don't perform the animation if this haptic dot
                        // is still in touchedGridPoints, i.e. slow drag.
                        if !touchedGridPoints.contains(touchedDotData.gridPoint) {
                            withAnimation(.linear(duration: colorAnimationDuration)) {
                                let insertion = touchedGridPoints.insert(touchedDotData.gridPoint)
                                if insertion.inserted {
                                    hapticEngine.asyncPlayHaptic(
                                        intensity: feedbackIntensity, sharpness: feedbackIntensity
                                    )
                                }
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + colorAnimationDuration) {
                                // There is a bug here more visible when the animationDuration is long.
                                // When the point is removed, the colors for
                                // the dots still in touchedGridPoints get recalculated,
                                // so they change colors every time one gets removed.
                                // This doesn't happen when they're added though?
                                withAnimation {
                                    _ = touchedGridPoints.remove(touchedDotData.gridPoint)
                                }
                            }
                        }
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
        view.hapticDotData = Set<HapticDotPreferenceData>()
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
        view.dotPadding = length ?? 5
        return view
    }

    /// Changes the padding between the dots.
    /// - Parameter length: How much padding to apply to the edges.
    public func dotPadding(_ length: CGFloat? = nil) -> HapticGrid {
        var view = self
        view.dotPaddingEdges = .all
        view.dotPadding = length ?? 5
        return view
    }

    /// Changes the default dot color.
    /// - Parameter color
    public func dotColor(_ color: Color) -> HapticGrid {
        var view = self
        view.hapticDotColor = color
        return view
    }
}

#Preview {
    HapticGrid<HapticEngine>()
        .environmentObject(HapticEngine())
}
