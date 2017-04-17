//
//  ForgetPasswordViewController.swift
//  ChatDemo
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
let Number = 6;// ID长度
let SourceStr = "0123456789"; // ID随机字符
class ForgetPasswordViewController: BaseNavagationMemberViewController,UITextFieldDelegate {


    
    @IBOutlet weak var telTextField: MyTextField!
    @IBOutlet weak var obtainAuthCodeTextField:MyTextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var sendCode: CountDownButton!
    var alert:TFQAlertUtil = TFQAlertUtil()
    var code=""//验证码
    var Email : String!
    var UserId : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf8f8f8)
        sendCode.setTitleColor(UIColor(rgbByFFFFFF: 0x27B0E1), forState: UIControlState.Normal)
        
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 5
        
        telTextField.delegate=self
        telTextField.placeholder = "请输入邮箱账号"
        var img = UIImageView(image: UIImage(named: "圆zw"))
        img.frame = CGRectMake(0, 0, 11, 16)
        telTextField!.leftView = img
        telTextField!.leftViewMode = UITextFieldViewMode.Always
        telTextField!.backgroundColor = UIColor.whiteColor()
        telTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        // 验证码
        var img1 = UIImageView(image: UIImage(named: "钥匙zw"))
        img1.frame = CGRectMake(0, 0, 11, 16)
        obtainAuthCodeTextField!.leftView = img1
        obtainAuthCodeTextField?.delegate=self
        obtainAuthCodeTextField!.leftViewMode = UITextFieldViewMode.Always
        obtainAuthCodeTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        obtainAuthCodeTextField!.backgroundColor = UIColor.whiteColor()
       
        telTextField.text = Email        
    }
    // 返回随机字符串
    func generateTradeNO() -> String
    {
        var resultStr = NSMutableString()
        srand(UInt32(time(nil)));
        for i in 1...Number
        {
            var index = rand() % Int32(count(SourceStr))
            var oneStr = (SourceStr as NSString).substringWithRange(NSMakeRange(Int(index), 1))
            resultStr.appendString(oneStr)
        }
        return resultStr as String
    }

    @IBAction func sendCodeAction(sender: AnyObject) {
        if(telTextField!.text.isEmpty || telTextField!.text == "")
        {
            messageBox.showAlert("邮箱账号不能为空")
            return
        }
        else if !VerificatePhoneFormat.validateEmail(telTextField!.text)
        {
            return
        }
        else
        {
            self.sendCode.startTimer()
            code = generateTradeNO()
            
            var paramers = ["code":code,"mail":telTextField!.text]
            AFNetworkTool.postJSONWithUrl(SendMailURL, parameters: paramers, success: { (jsonData) -> Void in
                var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
                var result = data["res"] as! String
                if result == "1"
                {
                    messageBox.showAlert("发送成功，请注意查收")
                    println(self.code)
                }
                else
                {
                    messageBox.showAlert(data["msg"] as! String)
                }
                
            }, fail: { (error) -> Void in
                messageBox.showAlert("发送邮件未成功0")
            })
        }
    }
    @IBAction func nextButtonClick(sender: AnyObject)
    {
        
        if(telTextField!.text.isEmpty || telTextField!.text == "")
        {
            alert.text="邮箱账号不能为空"
            alert.showAlert()
            return
        }
        else if !VerificatePhoneFormat.validateEmail(telTextField!.text)
        {
            alert.text="邮箱格式不正确!"
            alert.showAlert()
            return
        }
        else if (obtainAuthCodeTextField!.text.isEmpty || obtainAuthCodeTextField!.text == "")
        {
            alert.text="验证码不能为空!"
            alert.showAlert()
            return()
        }
        else if (obtainAuthCodeTextField!.text != code)
        {
            alert.text="您输入的验证码有误!"
            alert.showAlert()
            return()
        }else
        {
            netWorkRequestForget()
        }
        
    }
    
    var editPassWordVC:EditPassWordViewController!
    //MARK: -- 忘记密码
    func netWorkRequestForget()
    {
        if (editPassWordVC == nil)
        {
            var sb = UIStoryboard(name: "Main", bundle: nil)
            editPassWordVC = sb.instantiateViewControllerWithIdentifier("EditPassWordViewController") as! EditPassWordViewController
            editPassWordVC.userID = self.UserId
        }
        self.navigationController?.pushViewController(editPassWordVC, animated: true)
    }
    
   override func  touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
     self.view.endEditing(true)
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        TextFieldListener.shareInstance().currentTextField = textField
    }

}
