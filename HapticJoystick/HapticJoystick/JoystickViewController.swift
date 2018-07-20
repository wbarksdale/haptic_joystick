//
//  JoystickViewController.swift
//  HapticJoystick
//
//  Created by William Barksdale on 7/20/18.
//  Copyright © 2018 William Barksdale. All rights reserved.
//

import Foundation
import UIKit

class JoystickViewController: UIViewController {
    
    let joystickView = JoystickView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        joystickView.center = CGPoint(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 2.0)
        self.view.addSubview(joystickView)
    }
}
