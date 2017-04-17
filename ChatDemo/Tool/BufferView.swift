//
//  bufferView.swift
//  ChatDemo
//
//  Created by user on 15/9/18.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
let SelfHeight = UIScreen.mainScreen().bounds.size.height
let SelfWidth = UIScreen.mainScreen().bounds.size.width
class BufferView: UIWindow {
    var buffer:UIView!
    var bufferActivity:UIActivityIndicatorView!
    private struct instance
    {
        static var instance : BufferView = BufferView()
    }
    private struct instanceGif
    {
        static var instance : BufferView = BufferView()
    }
    var blackView:UIView!
    // 提示信息
    var label:UILabel!
    /// gif控件
    var gifView:MyGifView!
    
    override init(frame: CGRect)
    {
        let rect = CGRect(x: 0, y: 0, width: SelfWidth, height: SelfHeight)
        super.init(frame: rect)
        AddView()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    func AddView()
    {
        var bufferRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        buffer = UIView(frame: bufferRect)
        buffer.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        bufferActivity = UIActivityIndicatorView(frame: CGRect(x: (bufferRect.width-37)/2, y: (bufferRect.height-37)/2, width: 37, height: 37))
        bufferActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        bufferActivity.color = UIColor.whiteColor()
        bufferActivity.startAnimating()
        buffer.addSubview(bufferActivity)

        
        
        let rect = CGRect(x: 0, y: 0, width: SelfWidth, height: SelfHeight)
        let backViewRect = CGRect(x: (rect.width-120)/2, y: (rect.height-120)/2, width: 120, height: 120)
        blackView = UIView(frame: backViewRect)
        blackView.layer.cornerRadius = 10
        blackView.layer.masksToBounds = true
        blackView.backgroundColor = UIColor.blackColor()
        self.addSubview(blackView)
        
        let activity = UIActivityIndicatorView(frame: CGRect(x: (backViewRect.width-37)/2, y: (backViewRect.height-37)/2-20, width: 37, height: 37))
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activity.startAnimating()
        activity.color = UIColor.whiteColor()
        blackView.addSubview(activity)
        
        label = UILabel(frame: CGRect(x: 0, y: (backViewRect.height-37)/2+20, width: backViewRect.width, height: 30))
        label.text = "加载中.."
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(17)
        label.textColor = UIColor.whiteColor()
        blackView.addSubview(label)
        
        gifView = MyGifView(frame:CGRect(x: (screenWidth-204)/2, y: (screenHeight-94)/2, width: 204, height: 94), filePath: NSBundle.mainBundle().pathForResource("加载中", ofType: "gif"))
        self.addSubview(gifView)
        
        self.backgroundColor = UIColor.whiteColor()
        self.alpha = 0
        
    }
    func showGif()
    {
        gifView.hidden = false
        blackView.hidden = true
    }
    func hidenGif()
    {
        gifView.hidden = true
        blackView.hidden = false
    }
    func show(superView:UIView)
    {
        self.buffer.alpha = 1
        if buffer.superview != superView
        {
            var bufferRect = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
            buffer.frame = bufferRect
            bufferActivity.frame = CGRect(x: (bufferRect.width-50)/2, y: (bufferRect.height-50)/2, width: 50, height: 50)
            superView.addSubview(buffer)
            superView.bringSubviewToFront(buffer)
        }
    }
    /**
    -    隐藏缓存界面
    -    :param: immediately 是否渐变隐藏 （true:渐变隐藏 false:立刻隐藏）
    */
    func hiden(immediately:Bool=false)
    {
        if (buffer != nil)
        {
            if immediately
            {
                self.buffer.alpha = 0
            }
            else
            {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.buffer.alpha = 0
                })
            }
        }
    }
    /**
    显示缓冲界面
    */
    class func show()
    {
        instance.instance.alpha = 1
        instance.instance.hidden = false
        instanceGif.instance.hidenGif()
        instance.instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
    }
    /**
     显示缓冲界面
     */
    class func showGif()
    {
        instanceGif.instance.alpha = 1
        instanceGif.instance.hidden = false
        instanceGif.instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        instanceGif.instance.showGif()
    }
    /**
    隐藏缓冲界面
    
    - parameter immediately: 是否直接隐藏
    */
    class func hiden()
    {
//        if immediately
//        {
//            instance.instance.alpha = 0
//            instance.instance.hidden = true
//        }
//        else
//        {
        
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                instance.instance.alpha = 0
                instanceGif.instance.alpha = 0
            })
//        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
