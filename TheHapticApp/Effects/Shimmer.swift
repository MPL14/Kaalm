//
//  Shimmer.swift
//  TheHapticApp
//We we no longer need this 


import SwiftUI

extension View {
    /// Adds an animated shimmer effect to the view using masking.
    func shimmer(_ config: ShimmerConfiguration) -> some View {
        modifier(ShimmerEffect(config: config))
    }
}

struct ShimmerConfiguration {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
}

fileprivate struct ShimmerEffect: ViewModifier {
    @State private var moveTo: CGFloat = -1.5
    var config: ShimmerConfiguration

    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        // The highlight for the shimmer.
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(
                                                colors: [
                                                    .white.opacity(0),
                                                    config.highlight.opacity(config.highlightOpacity),
                                                    .white.opacity(0)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .blur(radius: config.blur)
                                        .rotationEffect(.degrees(0))
                                        .offset(x: geometry.size.width * moveTo)
                                }
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        withAnimation(.easeIn(duration: 2.5).repeatForever(autoreverses: false)) {
                            moveTo = 1.5
                        }
                    }
                    .allowsHitTesting(false)
                    // Allows the underlying view to be interacted with,
                    // since the shimmer effect is placed on top of it.
            }
    }
}

#Preview {
    ZStack {
        Color("Default")
            .ignoresSafeArea()
        VStack(spacing: 20) {
            SwipeToUnlock<HapticEngine> {
                print("hi")
            }
            .shimmer(.init(tint: .white.opacity(0.2), highlight: .gray, blur: 5))

            Text("Swipe to Open")
                .font(.headline)
                .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
        }
    }
    .environmentObject(HapticEngine())
}
