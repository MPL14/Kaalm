//
//  SettingsView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/30/24.
//

import MessageUI
import StoreKit
import SwiftUI

struct SettingsView: View {
    // MARK: - Environment
    @Environment(\.requestReview) var requestReview

    // MARK: - State
    // Send Support Email
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var showingMailError = false

    var body: some View {
        List {
            Section("About") {
                aboutButton

                requestReviewButton

                supportEmailButton
            }

            VStack {
                Text("The Haptic App, v\(Bundle.main.releaseVersionNumber ?? "nil")")
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .listRowBackground(EmptyView())
            .listRowInsets(.init(top: 0, leading: 0, bottom: 30, trailing: 0))
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result)
        }
        .alert("Error sending mail.", isPresented: $showingMailError) {
            Button("Ok") { }
        } message: {
            Text("Unable to send email from this device.")
        }
        .navigationTitle("Settings")
    }

    // MARK: - Subviews
    private var aboutButton: some View {
        NavigationLink {
            VStack {
                Text("About")
            }
        } label: {
            Text("About")
        }
    }

    private var requestReviewButton: some View {
        Button(action: {}) {
            Button {
                Task {
                    await requestReview()
                }
            } label: {
                HStack {
                    Text("Rate The Haptic App")
                    Spacer()
                }
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 18, bottom: 0, trailing: 0))
        .tint(.blue)
    }

    private var supportEmailButton: some View {
        Button(action: {}) {
            Button {
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView = true
                } else {
                    self.showingMailError = true
                }
            } label: {
                HStack {
                    Text("Need Support?")
                    Spacer()
                }
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 18, bottom: 0, trailing: 0))
        .tint(.blue)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .navigationBarTitleDisplayMode(.inline)
    }
}
