//
//  GenericListButton.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 2/1/24.
//

import SwiftUI

struct LinkListButton: View {
    private var action: () -> ()
    private var labelText: String

    init(labelText: String, action: @escaping () -> Void) {
        self.action = action
        self.labelText = labelText
    }

    var body: some View {
        Button(action: {}) {
            Button {
                action()
            } label: {
                Text(labelText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
    }
}

#Preview {
    LinkListButton(labelText: "Test") {
        print("hi")
    }
}
