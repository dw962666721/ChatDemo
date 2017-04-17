//
//  LoginViewController.swift
//  LoginModule
//
//  Created by admin on 15-6-19.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//


class MyTextField: UITextField{
    override func leftViewRectForBounds(bounds: CGRect) -> CGRect
    {
        return CGRectOffset(self.leftView!.bounds, 20, 0.5 * (bounds.height - leftView!.bounds.height))
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect
    {
        return super.textRectForBounds(CGRectOffset(bounds,10, 0))
    }
    override func editingRectForBounds(bounds: CGRect) -> CGRect
    {
        return super.editingRectForBounds(CGRectOffset(bounds, 10, 0))
    }
}

class LoginViewController: BaseNavagationMemberViewController,UITextFieldDelegate {

    @IBOutlet weak var textImportView: UIView! // 文本输入view
    
    @IBOutlet weak var telTextField: MyTextField!
    
    @IBOutlet weak var psdTextField: MyTextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var forgetPasswordBtn: UIButton!

    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tencentBtn: UIButton! //qq登录
    
    @IBOutlet weak var sinaBtn: UIButton!// 新浪登录
    
//    var request:ASIFormDataRequest!
//    convenience init(request:ASIFormDataRequest ) {
//        self.init()
//        self.request=request
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf8f8f8)
        textImportView.layer.borderColor = UIColor.grayColor().CGColor
        textImportView.layer.borderWidth = 0.3

        var telImage = UIImageView(frame: CGRectMake(80/2, 15, 20, 24))
        telImage = UIImageView(image: UIImage(named: "圆zw"))
        textImportView.addSubview(telImage)
        
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        
        // 锁图片
        var lockImage = UIImageView(frame: CGRectMake(80/2, 74, 20, 24))
        lockImage = UIImageView(image: UIImage(named: "锁zw"))
        textImportView.addSubview(lockImage)
        
        telTextField!.delegate = self
        telTextField.leftView = telImage
        telTextField!.leftViewMode = UITextFieldViewMode.Always
        telTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        telTextField!.backgroundColor = UIColor.whiteColor()
        telTextField!.leftViewRectForBounds(CGRectMake(20, 20, 20, 24))
        telTextField!.limitTextLength(15)
        
        psdTextField!.delegate = self
        psdTextField!.secureTextEntry = true
        psdTextField!.leftView = lockImage
        psdTextField!.leftViewMode = UITextFieldViewMode.Always
        psdTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        psdTextField!.backgroundColor = UIColor.whiteColor()
        psdTextField!.leftViewRectForBounds(CGRectMake(10, 20, 20, 24))
        
        
        registerBtn?.setTitleColor(UIColor(rgbByFFFFFF: 0x969696), forState: UIControlState.Normal)
        forgetPasswordBtn?.setTitleColor(UIColor(rgbByFFFFFF: 0x969696), forState: UIControlState.Normal)

        
//        if isReviewing(){
//            tencentBtn.hidden=true
//            sinaBtn.frame.origin.x=(self.view.frame.width-32)/2
            //wxinLoginBtn!.hidden=true
            //WeiboLoginBtn.frame.origin.x=QQLoginBtn!.frame.origin.x
            
//        }
        // WXin登录 暂时用不到
        //        wxinLoginBtn = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        //        wxinLoginBtn!.frame = CGRectMake(thirdLoginOrX + 2*(loginWidth + space),starY, 32, 32)
        //        wxinLoginBtn!.setImage(UIImage(named: "Weibo"), forState: UIControlState.Normal)
        //        wxinLoginBtn!.addTarget(self, action: "wxinLoginBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        //        wxinLoginBtn!.hidden=true
        //        scrollView?.addSubview(wxinLoginBtn)
    }

    @IBAction func nextClick(sender: AnyObject)
    {
        verificationThePhoneAndPassword()
    }
    @IBAction func tencentLoginClick(sender: AnyObject)
    {
        TencentLogin.login()
    }
    @IBAction func sinaLoginClick(sender: AnyObject)
    {
        SinaLogin.login()
    }
    //    func wxinLoginBtnClick(){
    //        //println("微信登陆")
    //        WXinLogin.login()
    //    }

    
    // 登录网络请求
    func loginNetworkRequest()
    {
        let psd=psdTextField!.text
        let tele=telTextField!.text
        let params = ["username": tele,"pwd":psd]
        AFNetworkTool.postJSONWithUrl(LoginURL, parameters: params, success: { (operation) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(operation as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary
            var result:String? = json?["res"] as? String
            if result == "1"
            {
                // 直接登录
                messageBox.showAlert("登陆成功！")
                var data = json as! [String:AnyObject]
                data["passWord"] = self.psdTextField!.text
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: ChatDemoUser)
                UserInfo.userInfo=data
                self.navigationController?.popToRootViewControllerAnimated(true)
                UserInfo.loginHX()
            }
            else
            {
                messageBox.showAlert(json?["msg"] as? String)
            }
            bufferInfoView.hiden()
            }, fail: { (error) -> Void in
                messageBox.showAlert("登陆木有成功额，是不是没开网络啊！！！")
                bufferInfoView.hiden()
        })


    }
    // 验证手机和密码格式
    func verificationThePhoneAndPassword()
    {
        // 判断字符串是否为空  if str3.isEmpty isEmpty是字符串的一个属性，判断字符串是否为空
        if(telTextField!.text.isEmpty || telTextField!.text == "")
        {
           messageBox.showAlert("帐号不能为空")
            return()
        }
        else if (TextValidate.valiExpression(telTextField!.text!))
        {
            messageBox.showAlert("账号不能包含表情!")
            return()
        }
        else if (psdTextField!.text.isEmpty || psdTextField!.text == "")
        {
            messageBox.showAlert("密码不能为空!")
            return()
        }
        loginNetworkRequest()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        TextFieldListener.shareInstance().currentTextField = textField
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        textField.resignFirstResponder()
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        MobClick.beginLogPageView("LoginViewController")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        MobClick.endLogPageView("LoginViewController")
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }

}
