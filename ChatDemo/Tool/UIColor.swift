//
//  UIColor.swift
//  ChatDemo
//
//  Created by user on 15/6/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
extension UIColor
{
    convenience init(rgbByFFFFFF:Int,alpha:CGFloat){
    self.init(red: CGFloat(Float((rgbByFFFFFF&0xff0000)>>0x10)/255), green:CGFloat(Float((rgbByFFFFFF&0xff00)>>8)/255), blue: CGFloat(Float(rgbByFFFFFF&0xff)/255), alpha: alpha)
    }
    
    convenience init(rgbByFFFFFF:Int) {
        self.init(rgbByFFFFFF: rgbByFFFFFF,alpha:1)
    }
}