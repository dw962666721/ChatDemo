//
//  CountDownButton.swift
//  CountDownButton
//
//  Created by admin on 15-1-26.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

//import UIKit
//protocol JSCountDownButtonDelegate:NSObjectProtocol{
//    func JSCountDownButtonDidChangeWithTitle(countDownButton:CountDownButton,second:Int)->String
//    func JSCountDownButtonDidFinishedChangeWithTitle(countDownButton:CountDownButton)->String
//
//}
let KSeconds = 60
class CountDownButton: UIButton {
    
    private var timer:NSTimer!
    private var seconds:Int = KSeconds//60秒倒计时
    //    weak var delegate:JSCountDownButtonDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame=frame;
        //self.addTarget(self, action: "startTimer", forControlEvents: UIControlEvents.TouchUpInside)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startTimer()
    {
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFireMethod:", userInfo: nil, repeats: true)
        changeJSCountDownButtonTitle()
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
        self.userInteractionEnabled=false
    }
    
    func timerFireMethod(theTimer:NSTimer)
    {
        //倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
        if (seconds == 1)
        {
            closeTimer()
        }else{
            changeJSCountDownButtonTitle()
        }
        
    }
    func changeJSCountDownButtonTitle()
    {
        seconds--
        self.titleLabel!.text = JSCountDownButtonDidChangeWithTitle(self.seconds)
        self.setTitle(JSCountDownButtonDidChangeWithTitle(self.seconds), forState: UIControlState.Normal)
    }
    func closeTimer()
    {
        //关闭定时器
        if self.timer != nil
        {
            self.timer.fireDate = NSDate.distantFuture() as! NSDate
            seconds = KSeconds
            self.setTitle(JSCountDownButtonDidFinishedChangeWithTitle(), forState: UIControlState.Normal)
            self.userInteractionEnabled=true
        }
    }
    
    func JSCountDownButtonDidChangeWithTitle(second:Int)->String
    {
        var title = String(format: "重发(%d)",second)
        return title
    }
    func JSCountDownButtonDidFinishedChangeWithTitle()->String
    {
        return "发送验证码"
    }
}
