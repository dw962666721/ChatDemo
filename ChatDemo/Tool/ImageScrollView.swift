//
//  ImageScrollView.swift
//  TimerScroll
//
//  Created by admin on 15-3-17.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

import UIKit
// 声明协议
@objc protocol ImageScrollViewDelegate:NSObjectProtocol
{
    func imageScrollView(imageScrollView:ImageScrollView,didSelectedAtIndex index:Int)
}
@objc protocol ImageScrollViewDatasource:NSObjectProtocol{
    func numberOfImageScrollView(imageScrollView:ImageScrollView)->Int
    func imageScrollView(imageScrollView:ImageScrollView,imageUrlAtIndex index:Int)->String
}
// 代理类
class ImageScrollView: UIView,TFQImageScrollViewDelegate,TFQImageScrollViewDatasource
{
    private var imageScrollView:TFQImageScrollView!
    var imageScrollViewDelegate:ImageScrollViewDelegate!
    
    var imageScrollViewDatasource:ImageScrollViewDatasource!
    var imageSize:CGSize{
        get{
            return imageScrollView.imageSize
        }
        set{
            imageScrollView.imageSize=newValue
        }
            
    }
    private var timer:NSTimer!
    private var pageControl:UIPageControl?
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        imageScrollView=TFQImageScrollView(frame: self.bounds)
        imageScrollView.imageScrollViewDelegate=self
        imageScrollView.imageScrollViewDatasource=self
        pageControl = UIPageControl(frame: CGRectMake((UIScreen.mainScreen().bounds.width - 10)/2, self.frame.size.height - 20, 10, 10))
        pageControl?.currentPage = 0
        pageControl?.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl?.pageIndicatorTintColor = UIColor.grayColor()
//      pageControl?.addTarget(self, action: "changePage:", forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(imageScrollView)
        self.addSubview(pageControl!)
        timerOn()
        NSThread.detachNewThreadSelector("reloadImages", toTarget: self, withObject: nil)
        
        
    }
    func imageScrollViewTouchBegin() {
        timerOff()
    }
    func imageScrollViewTouchEnd() {
        timerOn()
    }
    func reloadImages(){
        imageScrollView.reloadImages()
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    func imageScrollView(imageScrollView: TFQImageScrollView!, imageUrlAtIndex index: Int) -> String!
    {
        return self.imageScrollViewDatasource.imageScrollView(self, imageUrlAtIndex: index)
    }
    func numberOfImageScrollView(imageScrollView: TFQImageScrollView!) -> Int
    {
        var num=0
        if let temp = self.imageScrollViewDatasource?.numberOfImageScrollView(self){
            num=temp
        }
        pageControl?.numberOfPages=num
        return num
    }
    
    //每隔1秒播放图片，其实是每隔1秒调用imgPlay方法
    func timerOn()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: imageScrollView, selector: "nextImage", userInfo: nil, repeats: true)
        
        //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    //关闭定时器，并且把定时器设置为nil，这是习惯
    func timerOff()
    {
        if timer != nil
        {
            timer.invalidate()
            timer=nil
        }
    }
//    func timerStop()
//    {
//        timer.fireDate = NSDate.distantFuture() as NSDate
//    }
    func imageScrollView(imageScrollView: TFQImageScrollView!, didEndScrolltoIndex index: Int)
    {
        pageControl?.currentPage=index
    }
    func imageScrollView(imageScrollView: TFQImageScrollView!, didSelectedAtIndex index: Int)
    {
        // 传递代理 让别的类实现
        self.imageScrollViewDelegate.imageScrollView(self, didSelectedAtIndex: index)
    }
    
}
