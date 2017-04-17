//
//  BindViewController.swift
//  E_Education
//
//  Created by JohnSon on 15/6/23.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

import UIKit

class BindViewController:BaseNavagationMemberViewController,UITextFieldDelegate  {

    var openId:(id:String,type:String)! // qqOpenId
    @IBOutlet weak var textImportView: UIView!
    
    @IBOutlet weak var telTextField: MyTextField!
    @IBOutlet weak var obtainAuthCodeTextField:UITextField?
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var confirmPasswordTextField:UITextField!
    
    @IBOutlet weak var sendBtn: CountDownButton!
    
    var alert:TFQAlertUtil = TFQAlertUtil()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf8f8f8)
        
        textImportView.layer.borderColor = UIColor.grayColor().CGColor
        textImportView.layer.borderWidth = 0.3
        
        telTextField.delegate=self
        var img = UIImageView(image: UIImage(named: "圆zw"))
        img.frame = CGRectMake(0, 0, 11, 16)
        telTextField!.leftView = img;
        telTextField!.leftViewMode = UITextFieldViewMode.Always
        telTextField!.backgroundColor = UIColor.whiteColor()
        telTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        telTextField!.limitTextLength(11)
        
        // 验证码
        var img1 = UIImageView(image: UIImage(named: "钥匙zw"))
        img1.frame = CGRectMake(0, 0, 11, 16)
        obtainAuthCodeTextField!.leftView = img1
        obtainAuthCodeTextField?.delegate=self
        obtainAuthCodeTextField!.leftViewMode = UITextFieldViewMode.Always
        obtainAuthCodeTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        obtainAuthCodeTextField!.backgroundColor = UIColor.whiteColor()
        obtainAuthCodeTextField!.limitTextLength(6)
        
        // 密码
        var img2 = UIImageView(image: UIImage(named: "锁zw"))
        img2.frame = CGRectMake(0, 0, 11, 16)
        passwordTextField!.leftView = img2
        passwordTextField.delegate=self
        passwordTextField!.leftViewMode = UITextFieldViewMode.Always
        passwordTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        passwordTextField!.backgroundColor = UIColor.whiteColor()
        passwordTextField!.limitTextLength(12)
        
        var img3 = UIImageView(image: UIImage(named: "锁zw"))
        img3.frame = CGRectMake(0, 0, 11, 16)
        confirmPasswordTextField!.leftView = img3
        confirmPasswordTextField.delegate=self
        confirmPasswordTextField!.leftViewMode = UITextFieldViewMode.Always
        confirmPasswordTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        confirmPasswordTextField!.backgroundColor = UIColor.whiteColor()
        confirmPasswordTextField!.limitTextLength(12)
        
        sendBtn.setTitleColor(UIColor(rgbByFFFFFF: 0x59bdef), forState: UIControlState.Normal)

    }
    // 发送验证码
    @IBAction func sendButtonClick(sender: AnyObject)
    {
        if telTextField!.text.isEmpty || telTextField!.text == ""
        {
            self.alert.text="手机号不能为空"
            self.alert.showAlert()
            return()
        }
        if (Int(count(telTextField!.text!)) <  11)
        {
            alert.text="您输入的手机号有误!"
            alert.showAlert()
            return()
        }
        // 验证手机号格式的正则表达式为:
        if TextValidate.validPhoneNumber(telTextField!.text)
        {
           self.sendBtn.startTimer()
            
            let tele=telTextField!.text
            let params = ["telephone": tele]
//            AFNetworkTool.postJSONWithUrl(CheckBindUsersURL, parameters: params, success: { (operation) -> Void in
//                var json: [String:AnyObject]? = NSJSONSerialization.JSONObjectWithData(operation as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
//                var codeStatus = json!["status"] as! String!
//                if codeStatus == "4"
//                {
//                    self.alert.text = "验证码已发送,请注意查收"
//                }else
//                    if codeStatus == "-1"
//                    {
//                        self.alert.text = "手机号格式不正确"
//                        self.sendBtn.closeTimer()
//                    }
//                    else
//                    {
//                        self.alert.text = "用户已经绑定"
//                        self.navigationController?.popViewControllerAnimated(true)
//                        self.sendBtn.closeTimer()
//                }
//                self.alert.showAlert()
//                }, fail: { (error) -> Void in
//                    println("Error: " + error.localizedDescription)
//            })
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        MobClick.beginLogPageView("BindViewController")
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        MobClick.endLogPageView("BindViewController")
    }
    // 下一步按钮
    @IBAction func nextButtonClick(sender: AnyObject)
    {
        verificationMessage()
    }
    // 网络请求
    func registerNetworkRequest()
    {
        let openId = self.openId
        let tele=telTextField!.text
        let authCode=obtainAuthCodeTextField?.text
        let psd=passwordTextField.text
        var password:String = MD5Util.md5HexDigest(psd+"deshell"+tele)
        let params = ["telephone": tele,"verifyCode":authCode,"password":password,openId.type+"OpenId":openId.id]
//        
//        AFNetworkTool.postJSONWithUrl(CheckBindUsersURL, parameters: params, success: { (operation) -> Void in
//            var json: [String:AnyObject]? = NSJSONSerialization.JSONObjectWithData(operation as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
//            var registerStatus = json!["statusCode"] as! String!
//            if registerStatus == "1"
//            {
//            }
//            else if registerStatus == "3"
//            {
//                self.alert.text = "验证码有误"
//                self.alert.showAlert()
//            }
//            else if registerStatus == "4"
//            {
//                self.alert.text = "用户绑定成功"
//                self.alert.showAlert()
//                self.navigationController?.popToRootViewControllerAnimated(true)
//            }
//            else
//            {
//                self.alert.text = "用户不存在"
//                self.alert.showAlert()
//            }
//            }, fail: { (error) -> Void in
//                 println("Error: " + error.localizedDescription)
//        })
        
    }
    func verificationMessage()
    {
        if telTextField!.text.isEmpty || telTextField!.text == ""
        {
            self.alert.text="手机号不能为空"
            self.alert.showAlert()
            return()
        }
        else if (Int(count(telTextField!.text!)) <  11)
        {
            self.alert.text="您输入的手机号有误!"
            self.alert.showAlert()
            return()
        }
        else if (obtainAuthCodeTextField!.text.isEmpty || obtainAuthCodeTextField!.text == "")
        {
            self.alert.text="验证码不能为空!"
            self.alert.showAlert()
            return()
        }
        else if (Int(count(obtainAuthCodeTextField!.text!)) <  4)
        {
            self.alert.text="您输入的验证码有误!"
            self.alert.showAlert()
            return()
        }
        else if (passwordTextField!.text.isEmpty || passwordTextField!.text == "")
        {
            self.alert.text="密码不能为空!"
            self.alert.showAlert()
            return()
        }
        else if (confirmPasswordTextField!.text.isEmpty || confirmPasswordTextField!.text == "")
        {
            self.alert.text="确认密码不能为空!"
            self.alert.showAlert()
            return()
        }
        else if (passwordTextField!.text != confirmPasswordTextField.text)
        {
            self.alert.text="两次输入的密码不一致!"
            self.alert.showAlert()
            return()
        }
        else if VerificatePhoneFormat.verificatePhoneFormat(telTextField!.text)
        {
            registerNetworkRequest()
        }
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
}