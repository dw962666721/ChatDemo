//
//  GuidanceViewController.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class LoginAndRegistViewController: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate {
    
    
    var imageView:UIImageView!
    var loginBtn : UIButton!
    var registBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.image = UIImage(named: "LaunchScreen")
        
        registBtn = UIButton(frame: CGRect(x: 0, y: screenHeight-50, width: screenWidth/2, height: 50))
        registBtn.backgroundColor = UIColor(rgbByFFFFFF: 0x59bdef)
        registBtn.setTitle("注册", forState: UIControlState.Normal)
        registBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        registBtn.addTarget(self, action: "regist", forControlEvents: UIControlEvents.TouchUpInside)
        
        loginBtn = UIButton(frame: CGRect(x: screenWidth/2, y: screenHeight-50, width: screenWidth/2, height: 50))
        loginBtn.backgroundColor = UIColor.blackColor()
        loginBtn.setTitle("登录", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(imageView)
        self.view.addSubview(registBtn)
        self.view.addSubview(loginBtn)
    }
    
    func login()
    {
        var sb = UIStoryboard(name: "Main", bundle: nil)
        var vc =  sb.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func regist()
    {
         var sb = UIStoryboard(name: "Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("InputUserNameViewController") as!  InputUserNameViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        MobClick.beginLogPageView("GuidanceViewController")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NSNotificationCenter.defaultCenter().postNotificationName("logOut", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        MobClick.endLogPageView("GuidanceViewController")
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}