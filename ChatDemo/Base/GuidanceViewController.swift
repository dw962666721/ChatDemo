//
//  GuidanceViewController.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

let startBtnW = CGFloat(120)
let startBtnH = CGFloat(100)
class GuidanceViewController: UIViewController,UIScrollViewDelegate {
    
    
    var scrollView:UIScrollView!
    var indexControl = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(4*screenWidth, screenHeight)
        scrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollView)
        
        for var i=0; i<4; i++
        {
            var image:UIImage = UIImage()
            if IS_IPHONE_6
            {
                image = UIImage(named: "引导页6_\(i+1)h")!
            }
            else
            {
                image = UIImage(named: "引导页\(i+1)")!
            }

            var imgView:UIImageView = UIImageView(image:image)
            imgView.frame = CGRectMake(CGFloat(i) * CGFloat(screenWidth), 0, screenWidth, screenHeight)
            scrollView.addSubview(imgView)
            
            // 添加"开始体验"按钮
            if (i == 3)
            {
                // 让UIImageView跟用户进行交互（接收触摸事件）
                imgView.userInteractionEnabled = true
                // 创建按钮
                var startBtn:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                startBtn.frame = CGRectMake((screenWidth - startBtnW)/2, 0.75*screenHeight, startBtnW, startBtnH)
                startBtn.backgroundColor = UIColor.clearColor()
                startBtn.addTarget(self, action: "start", forControlEvents:.TouchUpInside)
                imgView.addSubview(startBtn)
            }
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
      
    }
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView)
    {
        var index:CGFloat = scrollView.contentOffset.x / screenWidth
        if index>3
        {
            start()
        }
    }
    func start()
    {
        var info:NSDictionary = NSBundle.mainBundle().infoDictionary!
        // 获取当前软件的版本号
        var currentVersion:String = info.objectForKey("CFBundleVersion") as! String
        
        // 从沙盒中取出版本号
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // 更新沙盒中的版本号
        defaults.setObject(currentVersion, forKey: "CFBundleVersion")
        // 同步到沙盒中
        defaults.synchronize()
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        MobClick.beginLogPageView("GuidanceViewController")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        MobClick.endLogPageView("GuidanceViewController")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}