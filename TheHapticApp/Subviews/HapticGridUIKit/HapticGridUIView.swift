import SwiftUI
import UIKit

struct HapticGridUIView<H: HapticPlaying>: UIViewRepresentable {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: H
//    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @AppStorage(Constants.gridRows) var currentGridRows: Double = Constants.defaultGridSize
    @AppStorage(Constants.gridCols) var currentGridCols: Double = Constants.defaultGridSize
    @AppStorage(Constants.dotSize) var currentDotSize: Double = Constants.defaultDotSize
    @AppStorage(Constants.myColor) var myColor: String = Constants.accentColor
    @AppStorage(Constants.darkModePreferred) var darkModePreferred: Bool = false
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.feedbackSharpness) var feedbackSharpness: Double = 1.0

    let frame: CGSize
    @State private var didAppear: Bool = false

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            feedbackIntensity: feedbackIntensity,
            feedbackSharpness: feedbackSharpness,
            gridColor: myColor,
            darkModePreferred: darkModePreferred,
            dotSize: currentDotSize,
            currentGridRows: currentGridRows,
            currentGridCols: currentGridCols,
            hapticEngine: hapticEngine
        )
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        context.coordinator.containerView = containerView
        context.coordinator.setupCircles(in: containerView)

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan))
        panGesture.delegate = context.coordinator
        containerView.addGestureRecognizer(panGesture)
        
        // For animation performance boost.
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("refreshing grid")
        context.coordinator.feedbackIntensity = self.feedbackIntensity
        context.coordinator.feedbackSharpness = self.feedbackSharpness
        context.coordinator.gridColor = self.myColor
        context.coordinator.darkModePreferred = self.darkModePreferred
//        context.coordinator.colorScheme = self.colorScheme
        context.coordinator.currentGridRows = self.currentGridRows
        context.coordinator.currentGridCols = self.currentGridCols
        context.coordinator.dotSize = self.currentDotSize
        
        uiView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        uiView.subviews.forEach({ $0.removeFromSuperview() })
        context.coordinator.setupCircles(in: uiView)

        // Only play animation on appear, not always.
        if !didAppear {
            uiView.transform = CGAffineTransform(scaleX: .leastNonzeroMagnitude, y: .leastNonzeroMagnitude)
            UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                uiView.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                uiView.layer.shouldRasterize = false
                didAppear = true
            }
        }
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var currentGridRows: Double
        var currentGridCols: Double
        var dotSize: Double
        var gridColor: String
        var darkModePreferred: Bool
//        var colorScheme: ColorScheme
        var feedbackIntensity: CGFloat
        var feedbackSharpness: CGFloat

        var containerView: UIView!
        var selectedCircle: UIView?
        var hapticEngine: H

        init(
            feedbackIntensity: CGFloat,
            feedbackSharpness: CGFloat,
            gridColor: String,
            darkModePreferred: Bool,
//            colorScheme: ColorScheme,
            dotSize: Double,
            currentGridRows: Double,
            currentGridCols: Double,
            hapticEngine: H
        ) {
            self.feedbackIntensity = feedbackIntensity
            self.feedbackSharpness = feedbackSharpness
            self.gridColor = gridColor
            self.darkModePreferred = darkModePreferred
//            self.colorScheme = colorScheme
            self.dotSize = dotSize
            self.currentGridRows = currentGridRows
            self.currentGridCols = currentGridCols
            self.hapticEngine = hapticEngine
        }

        func setupCircles(in view: UIView) {
            let circleDiameter: CGFloat = dotSize
            let circlePadding: CGFloat = 5.0
            // The total padding on both sides, i.e. the
            // padding on each side is circlePadding / 2.0.

            let viewHeight = view.frame.height
            let viewWidth = view.frame.width

            let idealRows = Int(viewHeight / (circleDiameter + circlePadding))
            let idealColumns = Int(viewWidth / (circleDiameter + circlePadding))

            let rows = min(idealRows, Int(currentGridRows))
            let columns = min(idealColumns, Int(currentGridCols))

            let heightPerRow = viewHeight / CGFloat(rows)
            let widthPerColumn = viewWidth / CGFloat(columns)

            let leftOverX = viewWidth - ((widthPerColumn * CGFloat(columns - 1)) + ((circleDiameter + circlePadding) / 2.0)) - ((circleDiameter + circlePadding) / 2.0)
            let leftOverY = viewHeight - ((heightPerRow * CGFloat(rows - 1)) + ((circleDiameter + circlePadding) / 2.0)) - ((circleDiameter + circlePadding) / 2.0)

            for i in stride(from: 0, to: rows, by: 1) {
                let ithRowPosition = (heightPerRow * CGFloat(i)) + ((circleDiameter + circlePadding) / 2.0) + (leftOverY / 2.0)

                for j in stride(from: 0, to: columns, by: 1) {
                    let jthColumnPosition = (widthPerColumn * CGFloat(j)) + ((circleDiameter + circlePadding) / 2.0) + (leftOverX / 2.0)

                    let circleView = HapticDotUIKit()
                    circleView.translatesAutoresizingMaskIntoConstraints = false
                    circleView.layer.bounds = CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter)
                    circleView.layer.position = CGPoint(x: jthColumnPosition, y: ithRowPosition)

                    circleView.layer.borderWidth = 0

                    let circleLayer = CAShapeLayer()
                    circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter)).cgPath
                    circleView.layer.mask = circleLayer

                    circleView.backgroundColor = UIColor(named: gridColor)

                    // Give the circles a tag of 1 so we can identify them for hit testing.
                    circleView.tag = 1

                    view.addSubview(circleView)
                }
            }
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let location = gesture.location(in: containerView)

            hapticEngine.asyncPlayHaptic(intensity: feedbackIntensity, sharpness: feedbackSharpness)

            // Identify the circle at the pan location.
            if let hitView = self.containerView.hitTest(location, with: nil) {
                if hitView.tag == 1 && selectedCircle != hitView {
                    // Update the color of the current circle.
                    UIView.animate(withDuration: 0.25) {
                        hitView.backgroundColor = UIColor.randomPastel
                        hitView.layer.opacity = 1.0
                    }

                    // Animate back to normal color.
                    UIView.animate(withDuration: 0.25, delay: 0.5) {
                        hitView.backgroundColor = UIColor(named: self.gridColor)
                        hitView.layer.opacity = 1.0
                    }

                    // Remember the currently selected circle.
                    selectedCircle = hitView
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(HapticEngine())
}
