//
//  ContentView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    let haptic = UIImpactFeedbackGenerator(style: .light)
    let defaults = UserDefaults.standard

    @State private var touchedCircles: [[Bool]] = Array(repeating: Array(repeating: false, count: 16), count: 16)

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                VStack {
                    Spacer()

                    ForEach(0..<16, id: \.self) { row in
                        HStack {
                            Spacer()

                            ForEach(0..<16, id: \.self) { column in
                                Circle()
                                    .fill(self.touchedCircles[row][column] ? Color.random : Color.black)
                                    .frame(width: 8, height: 8)  // Dot size
                                    .padding(2) //Padding for the dots
                                    .opacity(self.touchedCircles[row][column] ? 0.0 : 1.0)
                                    .animation(.easeOut(duration: 0.5), value: self.touchedCircles[row][column])
                            }

                            Spacer()
                        }
                    }

                    Spacer()
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let x = Int(value.location.x / (geometry.size.width / 16))
                            let y = Int(value.location.y / (geometry.size.height / 16))

                            if x >= 0 && x < 16 && y >= 0 && y < 16 {
                                self.haptic.impactOccurred()
                                self.touchedCircles[y][x] = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        self.touchedCircles[y][x] = false
                                    }
                                }
                            }
                        })
                )
            }
        }
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                withAnimation {
//                    showSplashScreen = false
//                    showDirections = defaults.bool(forKey: "directionsShown") == false
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
