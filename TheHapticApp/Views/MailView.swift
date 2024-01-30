//
//  MailView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/30/24.
//

import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    // MARK: - Environment
    @Environment(\.presentationMode) var presentation

    // MARK: - State
    @Binding var result: Result<MFMailComposeResult, Error>?

    // Coordinator acts like the delegate object.
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        // MARK: - Coordinator State
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            self._presentation = presentation
            self._result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }

            if let error {
                self.result = .failure(error)
                return
            }

            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator

        vc.setSubject("Feedback for The Haptic App")
        vc.setToRecipients(["thehapticapp@gmail.com"])

        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

