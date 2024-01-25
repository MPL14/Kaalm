//
//  HapticEngine.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/25/24.
//

import CoreHaptics
import SwiftUI

/// A class for playing haptics. Using a class allows to create only one
/// haptic engine for the whole app.
final class HapticEngine: HapticPlaying, ObservableObject {
    // MARK: - Properties
    private var hapticEngine: CHHapticEngine?

    /// Keep track of when the system stops our haptic engine.
    private var hapticEngineWasStopped: Bool

    init() {
        self.hapticEngine = nil
        self.hapticEngineWasStopped = false
    }

    // MARK: - Private Methods
    /// A synchronous function to start the haptic engine.
    private func syncPrepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }

        do {
            hapticEngine = try CHHapticEngine()

            /// This allows us to know if the haptic engine was
            /// stopped by the system.
            hapticEngine?.stoppedHandler = { [weak self] _ in
                self?.hapticEngineWasStopped = true
            }

            try hapticEngine?.start()
            print("Haptic engine started.")
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }

    /// An asynchronous function to start the haptic engine.
    private func asyncPrepareHaptics(_ completion: @escaping () -> Void) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }

        do {
            hapticEngine = try CHHapticEngine()

            /// This allows us to know if the haptic engine was
            /// stopped by the system.
            hapticEngine?.stoppedHandler = { [weak self] _ in
                self?.hapticEngineWasStopped = true
                print("hapticEngine stopped async")
            }

            hapticEngine?.start(completionHandler: { error in
                if let error {
                    print("There was an error asynchronously starting the haptic engine: \(error.localizedDescription)")
                } else {
                    completion()
                }
            })

            print("Haptic engine asynchronously started.")
        } catch {
            print("There was an error asynchronously creating the haptic engine: \(error.localizedDescription)")
        }
    }

    // MARK: - Public Methods
    /// Synchronously start the haptic engine if needed and then
    /// play a haptic based on the input haptic type.
    public func playHaptic(_ hapticType: HapticType) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }

        if hapticEngine == nil || hapticEngineWasStopped {
            /// When calling this for the first time, there is some lag
            /// due to using the synchronous start() method.
            syncPrepareHaptics()
            /// This only needs to be set if the hapticEngineWasStopped
            /// was true.
            hapticEngineWasStopped = false
        }

        do {
            var events: [CHHapticEvent] = []

            switch hapticType {
            case .swipeSuccess:
                events = swipeSuccessHaptic
            case .longPressSuccess:
                events = longPressSuccessHaptic
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }

    /// Asynchronously start the haptic engine if needed and then
    /// play a haptic based on the input haptic type through the start
    /// function's completion handler.
    public func asyncPlayHaptic(_ hapticType: HapticType) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }

        let playHapticsCompletion = { [weak self] in
            guard let self = self else { return }

            do {
                var events: [CHHapticEvent] = []

                switch hapticType {
                case .swipeSuccess:
                    events = swipeSuccessHaptic
                case .longPressSuccess:
                    events = longPressSuccessHaptic
                }

                let pattern = try CHHapticPattern(events: events, parameters: [])
                let player = try self.hapticEngine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print("Failed to play pattern: \(error.localizedDescription)")
            }
        }

        if hapticEngine == nil || hapticEngineWasStopped {
            /// Call the asynchronous version of prepareHaptics
            /// and pass playHapticsCompletion to run when
            /// the async function has completed.
            asyncPrepareHaptics(playHapticsCompletion)
            hapticEngineWasStopped = false
        } else {
            playHapticsCompletion()
        }
    }
}

