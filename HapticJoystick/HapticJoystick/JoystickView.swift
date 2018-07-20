//
//  JoystickView.swift
//  HapticJoystick
//
//  Created by William Barksdale on 7/20/18.
//  Copyright © 2018 William Barksdale. All rights reserved.
//

import Foundation
import UIKit

class JoystickView: UIView {
    
    let feedbackGenerator: JoystickFeedbackGenerator
    
    override init(frame: CGRect) {
        self.feedbackGenerator = JoystickTapRateFeedbackGenerator()
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2.0
        self.layer.cornerRadius = frame.height / 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func normalizedVectorFromTouchPoint(_ point: CGPoint) -> CGPoint {
        // NOTE: y gets inverted because view coordinates are in ULO
        let notNormalizedJoystickVector = CGPoint(x: point.x - bounds.midX, y: -(point.y - bounds.midY))
        let maxValue = bounds.size.width / 2.0
        assert(bounds.size.width == bounds.size.height)
        let rawX = notNormalizedJoystickVector.x / maxValue
        let rawY = notNormalizedJoystickVector.y / maxValue
        let clampedX = max(min(rawX, 1.0), -1.0)
        let clampedY = max(min(rawY, 1.0), -1.0)
        return CGPoint(x: clampedX, y: clampedY)
    }
    
    // MARK: Touches Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            let normalizedVector = normalizedVectorFromTouchPoint(touchPoint)
            feedbackGenerator.start(withNormalizedJoystickVector: normalizedVector)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            let normalizedVector = normalizedVectorFromTouchPoint(touchPoint)
            feedbackGenerator.update(withNormalizedJoystickVector: normalizedVector)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackGenerator.stop()
    }
}
