//
//  AlertView.swift
//  ChatDemo
//
//  Created by user on 15/7/3.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class AlertView: UIAlertView {

    override func show() {
        super.show()
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "performDismiss:", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    func performDismiss(timer:NSTimer)
    {
        self.dismissWithClickedButtonIndex(0, animated: false)
    }
}
