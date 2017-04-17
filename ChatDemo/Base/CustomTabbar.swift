//
//  CustomTabbar.swift
//  CustomTabbar
//
//  Created by user on 15/6/8.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
import Foundation
class CustomTabbar: UITabBar {
    private var count:Int!
//    override init() {
//        super.init()
//        setStyle()
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyle()
    }
    
    func setStyle()
    {
        self.count = self.items!.count
        var width:CGFloat = CGFloat(UIScreen.mainScreen().bounds.width) / CGFloat(self.count)
        for (var j=1;j<count;j++)
        {
            var lineView = UIView()
            lineView.frame = CGRectMake(CGFloat(j) * width - 0.5, 12, 0.5, 25)
            lineView.backgroundColor=UIColor.lightGrayColor()
            self.addSubview(lineView)
        }
        //  self.tintColor = UIColor.redColor()
    }
    @IBInspectable var lightColor : UIColor
        {
        get {return self.tintColor;}
        set{self.tintColor = newValue;}
    }
}
