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
    @Environment(\.openURL) var openURL

    // MARK: - State
    @ObservedObject private var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section("General") {
                aboutButton

                requestReviewButton
            }

            Section {
                supportEmailButton

                supportWebsiteButton

                privacyPolicyButton

                restorePurchasesButton
            } header: {
                Text("Support")
            } footer: {
                Text(viewModel.appVersionNumber)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                    .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $viewModel.isShowingMailView) {
            MailView(result: $viewModel.mailResult)
        }
        .alert(viewModel.alertMessageTitle,
               isPresented: $viewModel.showingAlert) { } message: {
            Text(viewModel.alertMessage)
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
                Task(priority: .userInitiated) {
                    requestReview()
                }
            } label: {
                Text("Rate The Haptic App")
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

    private var supportEmailButton: some View {
        Button(action: {}) {
            Button {
                viewModel.supportEmailButtonTapped()
            } label: {
                Text(viewModel.supportEmailButtonText)
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

    private var supportWebsiteButton: some View {
        Button(action: {}) {
            Button {
                guard let url = Constants.appSupportPageURL else { return }
                openURL(url)
            } label: {
                Text(viewModel.supportWebsiteButtonText)
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

    private var privacyPolicyButton: some View {
        Button(action: {}) {
            Button {
                guard let url = Constants.appPrivacyPolicyURL else { return }
                openURL(url)
            } label: {
                Text(viewModel.privacyPolicyWebsiteButtonText)
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

    private var restorePurchasesButton: some View {
        Button(action: {}) {
            Button {
                Task(priority: .userInitiated) {
                    await viewModel.restorePurchasesButtonTapped()
                }
            } label: {
                Text(viewModel.restorePurchasesButtonText)
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
    NavigationStack {
        SettingsView(SettingsViewModel())
            .navigationBarTitleDisplayMode(.inline)
    }
}
