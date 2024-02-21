//
//  HapticGrid.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import SwiftUI

struct HapticGrid<H: HapticPlaying>: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: H

    // MARK: - State
    @State private var touchedGridPoints: Set<GridPoint> = Set<GridPoint>()
    @State private var hapticDotData: Set<HapticDotPreferenceData> = Set<HapticDotPreferenceData>()
    @State private var gridScale: CGSize = .zero

    // MARK: - Properties
    private var gridDim: (Int, Int) = (10, 10)  // (row, column)

    private var dotSize: CGFloat = 25
    private var dotPaddingEdges: Edge.Set = .all
    private var dotPadding: CGFloat = 0

    private var hapticDotColor: Color = .primary
    private var colorAnimationDuration: CGFloat = 0.5

    private var feedbackSharpness: Double = 1.0
    private var feedbackIntensity: Double = 1.0

    var body: some View {
        GeometryReader { viewGeo in
            VStack(spacing: 0) {
                ForEach(0..<gridDim.0, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<gridDim.1, id: \.self) { column in
                            HapticDot(
                                size: determineIdealDotSize(viewGeo: viewGeo, defaultDotSize: dotSize, gridDim: gridDim)
                            )
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
            .frame(width: viewGeo.size.width, height: viewGeo.size.height, alignment: .center)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Haptic Dot Grid")
            .accessibilityHint("Plays haptics as you touch and drag.")
            .accessibilityAddTraits(.allowsDirectInteraction)
            .accessibilityIdentifier("hapticGrid")
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
                        hapticEngine.asyncPlayHaptic(
                            intensity: feedbackIntensity, sharpness: feedbackSharpness
                        )

                        // Don't perform the animation if this haptic dot
                        // is still in touchedGridPoints, i.e. slow drag.
                        if !touchedGridPoints.contains(touchedDotData.gridPoint) {
                            withAnimation(.linear(duration: colorAnimationDuration)) {
                                let _ = touchedGridPoints.insert(touchedDotData.gridPoint)
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

    private func determineIdealDotSize(viewGeo: GeometryProxy, defaultDotSize: CGFloat, gridDim: (Int, Int)) -> CGFloat {
        let idealWidth = min(defaultDotSize, (viewGeo.size.width - (CGFloat(gridDim.1)*dotPadding*2)) / CGFloat(gridDim.1))
        let idealHeight = min(defaultDotSize, (viewGeo.size.height - (CGFloat(gridDim.0)*dotPadding*2)) / CGFloat(gridDim.0))
        let idealSize = max(0, min(idealWidth, idealHeight))

        return idealSize
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
    /// - Parameter length: How much padding to apply to the edges.
    public func dotPadding(_ length: CGFloat? = nil) -> HapticGrid {
        var view = self
        view.dotPaddingEdges = .all
        view.dotPadding = length ?? 3
        return view
    }

    /// Changes the default dot color.
    /// - Parameter color
    public func dotColor(_ color: Color) -> HapticGrid {
        var view = self
        view.hapticDotColor = color
        return view
    }

    /// Changes the default feedback intensity and sharpness.
    /// - Parameter intensity
    /// - Parameter sharpness
    public func feedback(_ intensity: Double, _ sharpness: Double) -> HapticGrid {
        var view = self
        view.feedbackIntensity = intensity
        view.feedbackSharpness = sharpness
        return view
    }
}

#Preview {
    VStack {
        HapticGrid<HapticEngine>()
            .environmentObject(HapticEngine())
    }
}
