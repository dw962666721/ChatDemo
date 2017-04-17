//
//  EditPswViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class EditPswViewController: UIViewController {
    @IBOutlet weak var newPswtTextFiled0: UITextField!

    @IBOutlet weak var newPswTextFiled1: UITextField!
    @IBOutlet weak var oldPswTextFiled: UITextField!
    @IBOutlet weak var forgotView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "密码修改"
        NSBundle.mainBundle().loadNibNamed("EditPswViewController", owner: self, options: nil)[0]
        // Do any additional setup after loading the view.
        var rightBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        rightBtn.tintColor = UIColor(rgbByFFFFFF: 0x0079FD)
        self.navigationItem.setRightBarButtonItem(rightBtn, animated: true)
        
        var tap = UITapGestureRecognizer(target: self, action: "forgetPsw")
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        forgotView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func forgetPsw()
    {
        var sb = UIStoryboard(name: "Main", bundle: nil)
        var forgotVC = sb.instantiateViewControllerWithIdentifier("ForgetViewController0") as! ForgetViewController0
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    func verification()->Bool
    {
        var result = true
        if oldPswTextFiled.text.isEmpty
        {
            messageBox.showAlert("请输入旧密码")
            result = false
        }
        if newPswTextFiled1.text.isEmpty || newPswtTextFiled0.text.isEmpty
        {
            messageBox.showAlert("请输入新密码")
            result = false
        }
        if newPswTextFiled1.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != newPswtTextFiled0.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        {
            messageBox.showAlert("新密码输入不一致")
            result = false
        }
        return result
    }
    func save()
    {
        if verification()
        {
            var parameters = ["userid":UserInfo.userID,"oldpwd":oldPswTextFiled.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()),"newpwd":newPswTextFiled1.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())]
            bufferInfoView.show(self.view)
            AFNetworkTool.postJSONWithUrl(UploadPwdURL, parameters: parameters, success: { (jsonData) -> Void in
                var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
                var result = data["res"] as! String
                if result == "1"
                {
                    messageBox.showAlert("修改成功")
                    self.dealResult()
                }
                else
                {
                    messageBox.showAlert(data["msg"] as! String)
                }
                bufferInfoView.hiden()
                
            }, fail: { (error) -> Void in
                messageBox.showAlert("修改密码未成功0")
                 bufferInfoView.hiden()
            })
        }
    }
    func dealResult()
    {
        //注销环信
        EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true, completion:
            {(info,error) -> Void in
                // 退出登录 注销登录信息
                NSUserDefaults.standardUserDefaults().removeObjectForKey(ChatDemoUser)
                UserInfo.userInfo=nil
                self.toLoginAndRegistView()
            }, onQueue: nil)
        
    }
    func toLoginAndRegistView()
    {
        if !UserInfo.isLogin
        {
            NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView3", object: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
