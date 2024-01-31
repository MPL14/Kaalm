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
            Section {
                aboutButton

                requestReviewButton

                supportEmailButton

                restorePurchasesButton
            } header: {
                Text("About")
            } footer: {
                Text(viewModel.appVersionNumber)
                    .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $viewModel.isShowingMailView) {
            MailView(result: $viewModel.mailResult)
        }
        .alert(viewModel.mailErrorMessageTitle,
               isPresented: $viewModel.showingMailError) { } message: {
            Text(viewModel.mailErrorMessage)
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
        .listRowInsets(.init(top: 0, leading: 7, bottom: 0, trailing: 0))
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
        .listRowInsets(.init(top: 0, leading: 7, bottom: 0, trailing: 0))
        .tint(.clear)
    }

    private var restorePurchasesButton: some View {
        Button(action: {}) {
            Button {
                viewModel.supportEmailButtonTapped()
            } label: {
                Text(viewModel.restorePurchasesButtonText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 7, bottom: 0, trailing: 0))
        .tint(.clear)
    }

    private var testButton: some View {
        Button(action: {}) {
            Button(action: {
                print("hi")
            }) {
                Text("Purchase Premium for $0.99")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowBackground(EmptyView())
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .tint(.blue)
    }

    private var appVersionNumberTag: some View {
        VStack {
            Text(viewModel.appVersionNumber)
                .frame(maxWidth: .infinity)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .listRowBackground(EmptyView())
        .listRowInsets(.init(top: 0, leading: 0, bottom: 30, trailing: 0))
    }
}

#Preview {
    NavigationStack {
        SettingsView(SettingsViewModel())
            .navigationBarTitleDisplayMode(.inline)
    }
}
