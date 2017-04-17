//
//  UIBarButtonItemExtension.swift
//  Text
//
//  Created by admin on 15-6-24.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

import Foundation

extension UIBarButtonItem
{
    // 导航栏右边标题按钮
    class func barButtonItemWithTitle(title:String,target:AnyObject, action:Selector)->UIBarButtonItem
    {
        
        var loginBtn:UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as!  UIButton
        loginBtn.frame = CGRectMake(0, 60, 100, 44)
        
        loginBtn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        loginBtn.setTitle(title, forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        loginBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        return UIBarButtonItem(customView:loginBtn)
    }
    // 导航栏右边图片按钮
    class func barButtonItemWithIcon(icon:String,highlightedIcon:String,target:AnyObject, action:Selector)->UIBarButtonItem
    {
        var loginBtn:UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as!  UIButton
        loginBtn.frame = CGRect(origin: CGPointZero, size: CGSizeMake(44, 44))
        loginBtn.setImage(UIImage(named: icon), forState: UIControlState.Normal)
        loginBtn.setImage(UIImage(named: highlightedIcon), forState: UIControlState.Highlighted)
        loginBtn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView:loginBtn)
    }
    class func barButtonItemWithWidth(seperateWidth:CGFloat)->UIBarButtonItem
    {
        var negativeSeperator:UIBarButtonItem=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSeperator.width=seperateWidth
        return negativeSeperator
    }
}