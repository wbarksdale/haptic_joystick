//
//  JoystickTapRateFeedbackGenerator.swift
//  HapticJoystick
//
//  Created by William Barksdale on 7/20/18.
//  Copyright © 2018 William Barksdale. All rights reserved.
//

import Foundation
import UIKit

/// This Joystick Feedback Generator uses a timer to generate feedback at a rate
/// determined by the magnitude of the normalized joystick vector provided to calls to `updateJoystickVector`
/// a larger magnitude vector will increase the rate of haptic feedback, while a low magnitude will
/// decrease the rate of haptic feedback. The "weight" of the taps will also be determined by the vectors
/// proximity to one of the "poles" of the joystick (i.e. North/East/South/West position)
/// A joystick position of due North or due East will generate heavy feedback, while a joystick
/// position of North East will generate light feedback. In theory, this allows the user
/// to sense the position of their thumb on the joystick without looking at it.
class JoystickTapRateFeedbackGenerator: JoystickFeedbackGenerator {
    
    private enum Constants {
        static let tickInterval: TimeInterval = 0.1
    }
    
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let heavy = UIImpactFeedbackGenerator(style: .heavy)
    private var timer: Timer?
    
    
    func start(normalizedJoystickVector: CGPoint) {
        timer = Timer(timeInterval: Constants.tickInterval, target: self,
                      selector: #selector(tick(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        light.prepare()
        medium.prepare()
        heavy.prepare()
        
        print("Start with joystick vector: \(normalizedJoystickVector)")
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        print("Stop")
    }
    
    func updateJoystickVector(_ normalizedJoystickVector: CGPoint) {
        // TODO: update internal state with the provided joystick vector
        print("Update with joystick vector: \(normalizedJoystickVector)")
    }
    
    @objc private func tick(timer: Timer) {
        // TODO: implement different feedback
        medium.impactOccurred()
    }
}
