//
//  AboutView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 2/1/24.
//

import SwiftUI

struct AboutView: View {
    @AppStorage(Constants.myColor) var myColor: String = Constants.accentColor

    private let aboutText: String = String(localized:
    """
    The Haptic App is intended to allow for a quick \
    reprieve from daily life. Simply place your finger \
    on the grid and drag to feel the haptics and see an \
    array of beautiful colors. \


    If you are enjoying the app, we hope you would consider \
    purchasing access to our premium features to customize your \
    Haptic App experience. Or leave us a \
    review on the App Store.
    """
    )

    private var appVersionNumber: String {
        return String(localized: "The Haptic App, v\(Bundle.main.releaseVersionNumber ?? "nil")")
    }

    var body: some View {
        List {
            VStack(spacing: 20) {
                HStack {
                    Image("TheHapticAppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .clipShape(.rect(cornerRadius: 20, style: .circular))
                        .shadow(radius: 5)

                    Text(appVersionNumber)
                        .font(.headline)
                        .padding()
                }

                Text(aboutText)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical)
        }
        .toolbarTitle(Text("Settings"), color: Color(myColor))
    }
}

#Preview {
    NavigationStack {
        AboutView()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
    }
}
