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
    
    private enum Constants {
        static let arrowSize = CGSize(width: 30, height: 25)
    }
    
    private let feedbackGenerator: JoystickFeedbackGenerator
    
    private let topArrow = CAShapeLayer()
    private let rightArrow = CAShapeLayer()
    private let bottomArrow = CAShapeLayer()
    private let leftArrow = CAShapeLayer()
    
    override init(frame: CGRect) {
        self.feedbackGenerator = JoystickTapRateFeedbackGenerator()
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2.0
        self.layer.cornerRadius = frame.height / 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.yellow
        drawArrows(arrowSize: Constants.arrowSize)
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
    
    // MARK: Triangle Drawing
    
    private func drawArrows(arrowSize: CGSize) {
        topArrow.removeFromSuperlayer()
        rightArrow.removeFromSuperlayer()
        bottomArrow.removeFromSuperlayer()
        leftArrow.removeFromSuperlayer()
        
        // need bounds, otherwise layer is dimensionless and math fails
        let arrowBounds = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: arrowSize)
        topArrow.bounds = arrowBounds
        rightArrow.bounds = arrowBounds
        bottomArrow.bounds = arrowBounds
        leftArrow.bounds = arrowBounds
        
        let arrowPath = arrowShapePath(arrowSize: arrowSize).cgPath
        topArrow.path = arrowPath
        rightArrow.path = arrowPath
        bottomArrow.path = arrowPath
        leftArrow.path = arrowPath
        
        let size = bounds.size
        topArrow.frame.origin = CGPoint(x: (size.width / 2.0) - (arrowSize.width / 2.0), y: 0.0)
        rightArrow.frame.origin = CGPoint(x: size.width - arrowSize.height, y: (size.height / 2.0) - (arrowSize.width / 2.0))
        bottomArrow.frame.origin = CGPoint(x: (size.width / 2.0) - (arrowSize.width / 2.0), y: size.height - arrowSize.height)
        leftArrow.frame.origin = CGPoint(x: 0.0, y: (size.height / 2.0) - (arrowSize.width / 2.0))
        
        // rotate arrows about the z axis (i.e depth)
        rightArrow.transform = CATransform3DRotate(rightArrow.transform, CGFloat.pi / 2.0, 0, 0, 1)
        bottomArrow.transform = CATransform3DRotate(bottomArrow.transform, CGFloat.pi, 0, 0, 1)
        leftArrow.transform = CATransform3DRotate(leftArrow.transform, 3 * CGFloat.pi / 2.0, 0, 0, 1)
        
        topArrow.fillColor = UIColor.blue.cgColor
        rightArrow.fillColor = UIColor.blue.cgColor
        bottomArrow.fillColor = UIColor.blue.cgColor
        leftArrow.fillColor = UIColor.blue.cgColor
        
        self.layer.addSublayer(topArrow)
        self.layer.addSublayer(rightArrow)
        self.layer.addSublayer(bottomArrow)
        self.layer.addSublayer(leftArrow)
    }
    
    
    private func arrowShapePath(arrowSize: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: arrowSize.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: arrowSize.width, y: arrowSize.height))
        path.addLine(to: CGPoint(x: 0, y: arrowSize.height))
        path.addLine(to: CGPoint(x: arrowSize.width / 2.0, y: 0))
        path.close()
        return path
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
