//
//  HapticsManager.swift
//  Runner
//
//  Created by David G Chopin on 3/5/21.
//

import Foundation
import CoreHaptics

@available(iOS 13.0, *)
class HapticsManager {
    static let shared: HapticsManager = HapticsManager()
    
    var engine: CHHapticEngine?
    
    func start() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        // create a dull, strong haptic
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        // create a curve that fades from 1 to 0 over one second
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: 0.5, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

        // use that curve to control the haptic strength
        let sharpnessParameter = CHHapticParameterCurve(parameterID: .hapticSharpnessControl, controlPoints: [start, middle, end], relativeTime: 0)
        let intensityParameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle, end], relativeTime: 0)

        // create a continuous haptic event starting immediately and lasting one second
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: 1)

        do {
            
            engine = try CHHapticEngine()
            try engine?.start()
            
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [sharpnessParameter, intensityParameter])

            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}
