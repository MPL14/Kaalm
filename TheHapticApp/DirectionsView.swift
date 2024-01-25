//
//  DirectionsView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import SwiftUI

struct DirectionsView: View {
    @Binding var showDirections: Bool
    let defaults = UserDefaults.standard

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 8) {
                Text("Directions: ")
                  .font(Font.custom("SF Pro Display", size: 42))
                  .foregroundColor(.white)

                Text("Press a circle & Swipe in any direction to activate feedback.")
                  .font(Font.custom("SF Pro Text", size: 24))
                  .foregroundColor(.white)

                Image("Group 1")
                    .frame(width: 80.08918, height: 136.59676)

                Image("Group 2")
                    .frame(width: 97.81862, height: 129.36569)

                Button(action: {
                    withAnimation {
                        showDirections = false
                        defaults.set(true, forKey: "directionsShown")
                    }
                }) {
                    Text("Continue")
                        .font(Font.custom("SF Pro Text", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 50)
            }
            .padding()
        }
    }
}
