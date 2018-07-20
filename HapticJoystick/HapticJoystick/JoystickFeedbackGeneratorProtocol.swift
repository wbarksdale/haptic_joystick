//
//  JoystickFeedbackGeneratorProtocol.swift
//  HapticJoystick
//
//  Created by William Barksdale on 7/20/18.
//  Copyright © 2018 William Barksdale. All rights reserved.
//

import Foundation
import UIKit

protocol JoystickFeedbacGenerator {
    /// Starts the feedback generator emitting haptic feedback, should be called when user begins touching
    /// the joystick
    func start(normalizedJoystickVector: CGPoint)
    
    /// Stops emitting haptic feedback, should be called when the user lifts their finger off the joystick
    func stop()
    
    /// Updates the joystick position using a normalized vector.
    /// For Example:
    /// a vector of [1, 1] indicates the joystick is positioned at maximum up and maximum right
    /// a vector of [0, -1] indicates the joystick is positioned directly down with no left / right input
    func updateJoystickVector(normalizedJoystickVector: CGPoint)
}
