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
        /// The frequency of ticks in seconds
        static let tickInterval: TimeInterval = 0.075
        
        /// Indicates that with a zero tap rate, feedback will be generated every
        /// `idleTapInterval` seconds
        static let idleTapInterval: TimeInterval = 0.25
    }
    
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let heavy = UIImpactFeedbackGenerator(style: .heavy)
    private var timer: Timer?
    
    /// The time of the most recent haptic feedback generation, set using CACurrentMediaTime()
    private var lastTapTime: CFTimeInterval = 0.0
    
    /// A float from [0, 1] indicating how fast haptic feedback should be generated
    /// 0 indicates the slowest tap rate, while 1 indicates the fastest tap rate
    private var currentTapRate: Float = 0.0
    
    /// A float from [0, 1] indicate how heavy the haptic feedback should be
    /// 0 indicates the lightest haptic feedback while 1 indicates the heaviest haptic feedback
    private var currentTapWeight: Float = 0.0
    
    func start(withNormalizedJoystickVector vector: CGPoint) {
        timer = Timer(timeInterval: Constants.tickInterval, target: self,
                      selector: #selector(tick(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        light.prepare()
        medium.prepare()
        heavy.prepare()
        
        update(withNormalizedJoystickVector: vector)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func update(withNormalizedJoystickVector vector: CGPoint) {
        updateTapRate(withJoystickVector: vector)
        updateTapWeight(withJoystickVector: vector)
    }
    
    // MARK: Private
    
    private func updateTapRate(withJoystickVector vector: CGPoint) {
        let raw_magnitude = sqrt(pow(vector.x, 2.0) + pow(vector.y, 2.0))
        currentTapRate = Float(min(1.0, raw_magnitude))
        print("rate: \(currentTapRate)")
    }
    
    private func updateTapWeight(withJoystickVector vector: CGPoint) {
        let theta = abs(atan(vector.y / vector.x))
        let proximityToPole = min(theta, (CGFloat.pi / 2.0) - theta)
        let maxProximityToPole = CGFloat.pi / 4.0  // "45 degrees"
        currentTapWeight = Float(1.0 - (proximityToPole / maxProximityToPole))
    }
    
    @objc private func tick(timer: Timer) {
        // Number of seconds in between taps given current tap rate
        let currentTapInterval = TimeInterval(1.0 - currentTapRate) * TimeInterval(Constants.idleTapInterval)
        
        // The time at which the next tap should occur given tap rate
        let nextTapTime = lastTapTime + currentTapInterval
        let currentTime = CACurrentMediaTime()
        
        if currentTime > nextTapTime {
            lastTapTime = currentTime
            if (currentTapRate < 0.1) {
                // when close to center joystick, the weight information is not really helpful
                light.impactOccurred()
            } else {
                switch currentTapWeight {
                case 0.0...0.33: light.impactOccurred()
                case 0.33...0.66: medium.impactOccurred()
                case 0.66...1.0: heavy.impactOccurred()
                default: assert(false, "weight is outside acceptable range")
                }
            }
        }
    }
}
