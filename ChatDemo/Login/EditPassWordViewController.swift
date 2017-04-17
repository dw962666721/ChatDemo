//
//  EditPassWordViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class EditPassWordViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var newPassWordTextFiled0: MyTextField!

    @IBOutlet weak var newPassWordTextFiled1: MyTextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    var userID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var img1 = UIImageView(image: UIImage(named: "锁zw"))
        img1.frame = CGRectMake(0, 0, 11, 16)
        newPassWordTextFiled0!.leftView = img1
        newPassWordTextFiled0?.delegate=self
        newPassWordTextFiled0!.leftViewMode = UITextFieldViewMode.Always
        newPassWordTextFiled0!.layer.borderColor = UIColor.lightGrayColor().CGColor
        newPassWordTextFiled0!.backgroundColor = UIColor.whiteColor()
       
        
        var img2 = UIImageView(image: UIImage(named: "锁zw"))
        img2.frame = CGRectMake(0, 0, 11, 16)
        newPassWordTextFiled1!.leftView = img2
        newPassWordTextFiled1?.delegate=self
        newPassWordTextFiled1!.leftViewMode = UITextFieldViewMode.Always
        newPassWordTextFiled1!.layer.borderColor = UIColor.lightGrayColor().CGColor
        newPassWordTextFiled1!.backgroundColor = UIColor.whiteColor()
        
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
    func verification()->Bool
    {
        var result = true
        if newPassWordTextFiled0.text.isEmpty || newPassWordTextFiled1.text.isEmpty
        {
            result = false
            messageBox.showAlert("密码不能为空")
        }
        if newPassWordTextFiled0.text != newPassWordTextFiled1.text
        {
            result = false
            messageBox.showAlert("两次密码不一致")
        }
        
        return result
    }
    @IBAction func confirmAction(sender: AnyObject) {
        if verification()
        {
            var parameters = ["userid":userID,"newpwd":newPassWordTextFiled0.text]
            self.view.endEditing(true)
            bufferInfoView.show(self.view)
            AFNetworkTool.postJSONWithUrl(ChangePwdURL, parameters: parameters, success: { (jsonData) -> Void in
                var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
                var result = data["res"] as! String
                if result == "1"
                {
                    messageBox.showAlert("重置密码成功")
                    self.dealResult()
                }
                else
                {
                    messageBox.showAlert(data["msg"] as! String)
                }
                bufferInfoView.hiden()
            }, fail: { (error) -> Void in
                messageBox.showAlert("访问服务器失败")
            bufferInfoView.hiden()
            })
        }
    }
    func dealResult()
    {
        //注销环信
        EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true, completion:
            {(info,error) -> Void in
                self.toLoginAndRegistView()
            }, onQueue: nil)

    }
//    toLoginAndRegistView3
    func toLoginAndRegistView()
    {
        if UserInfo.isLogin
        {
            // 退出登录 注销登录信息
            NSUserDefaults.standardUserDefaults().removeObjectForKey(ChatDemoUser)
            UserInfo.userInfo=nil
            NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView3", object: nil)
        }
        else
        {
            NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView0", object: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
