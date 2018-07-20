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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2.0
        self.layer.cornerRadius = frame.height / 2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
