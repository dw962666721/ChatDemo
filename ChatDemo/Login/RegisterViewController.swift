//
//  RegisterViewController.swift
//  ChatDemo
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class RegisterViewController: BaseNavagationMemberViewController,UITextFieldDelegate,ChooseViewGroupDelegate ,ChooseViewDatasource,UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var telTextField: MyTextField!
    @IBOutlet weak var QQTextFiled: MyTextField!
    
    @IBOutlet weak var emailTextField: MyTextField!
    @IBOutlet weak var passwordTextField0:MyTextField?
    @IBOutlet weak var passwordTextField1:MyTextField!
    @IBOutlet weak var ageChooseView: DateChooseView!
    @IBOutlet weak var ageFiledText: MyTextField!
    @IBOutlet weak var sendBtn:CountDownButton?
    @IBOutlet weak var nextBtn: UIButton!

    @IBOutlet weak var sexChooseView: ChooseViewStyleClearDown!
    @IBOutlet weak var areaChooseView: LocationChooseViewGroupStyle!
    
    @IBOutlet weak var protocolImageView: UIImageView!
    @IBOutlet weak var protocolBtn: UIButton!
    
    var protocolState = 1 // 0:为同意协议 1:同意协议
    
    var userName:String!
    func numberOfComponentsInChooseView(chooseView: ChooseView!) -> Int
    {
        return 1
    }
    func chooseView(chooseView: ChooseView!, numberOfRowsInComponent componen: Int) -> Int
    {
        return 2
        
    }
    func chooseView(chooseView: ChooseView!, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return sexArray[row]        
    }
    func chooseViewSureButtonClicked(chooseView: ChooseView!) {
        if chooseView != ageChooseView
        {
            return
        }
        var value = chooseView.value
        if value == ""
        {
            ageFiledText.text="0"
        }
        var famater = NSDateFormatter()
        famater.dateFormat = "yyyy-MM-dd"
        var date = famater.dateFromString(value)!
        var nowDate = NSDate()
        if date.year <= nowDate.year
        {
            if date.month <= nowDate.month
            {
                if date.day <= nowDate.day
                {
                    ageFiledText.text = toString(nowDate.year - date.year + 1)
                }
                else
                {
                    ageFiledText.text = toString(nowDate.year - date.year)
                }
            }
            else
            {
                ageFiledText.text = toString(nowDate.year - date.year)
            }
        }
        else
        {
            ageFiledText.text="0"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        sexChooseView.datasource = self
        areaChooseView.delegate = self
        ageChooseView.datasource = self
        
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf8f8f8)
        var img = UIImageView(image: UIImage(named: "圆zw"))
        img.frame = CGRectMake(0, 0, 11, 16)
       
//        var pan = UIPanGestureRecognizer(target: self, action: "hidenKeyBord")
//        contentView.addGestureRecognizer(pan)
        
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        
        
        var img0 = UIImageView(image: UIImage(named: "圆zw"))
        img0.frame = CGRectMake(0, 0, 11, 16)
        telTextField.delegate=self
//        telTextField!.leftView = img0
        telTextField!.leftViewMode = UITextFieldViewMode.Always
        telTextField!.backgroundColor = UIColor.whiteColor()
        telTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
        telTextField!.limitTextLength(11)
        
        var imgQQ = UIImageView(image: UIImage(named: "圆zw"))
        imgQQ.frame = CGRectMake(0, 0, 11, 16)
        QQTextFiled.delegate=self
//        QQTextFiled!.leftView = imgQQ
        QQTextFiled!.leftViewMode = UITextFieldViewMode.Always
        QQTextFiled!.backgroundColor = UIColor.whiteColor()
        QQTextFiled!.layer.borderColor = UIColor.lightGrayColor().CGColor
        QQTextFiled!.limitTextLength(15)

        var imgEmail = UIImageView(image: UIImage(named: "email_ICO"))
        imgEmail.frame = CGRectMake(0, 0, 11, 16)
        emailTextField.delegate=self
//        emailTextField!.leftView = imgEmail
        emailTextField!.leftViewMode = UITextFieldViewMode.Always
        emailTextField!.backgroundColor = UIColor.whiteColor()
        emailTextField!.layer.borderColor = UIColor.lightGrayColor().CGColor
//        emailTextField!.limitTextLength(15)

        
        // 密码1
        var img1 = UIImageView(image: UIImage(named: "锁zw"))
        img1.frame = CGRectMake(0, 0, 11, 16)
//        passwordTextField0!.leftView = img1
        passwordTextField0?.delegate=self
        passwordTextField0!.leftViewMode = UITextFieldViewMode.Always
        passwordTextField0!.layer.borderColor = UIColor.lightGrayColor().CGColor
        passwordTextField0!.backgroundColor = UIColor.whiteColor()
        passwordTextField0!.limitTextLength(12)
        
        // 密码2
        var img2 = UIImageView(image: UIImage(named: "锁zw"))
        img2.frame = CGRectMake(0, 0, 11, 16)
//        passwordTextField1!.leftView = img2
        passwordTextField1.delegate=self
        passwordTextField1!.leftViewMode = UITextFieldViewMode.Always
        passwordTextField1!.layer.borderColor = UIColor.lightGrayColor().CGColor
        passwordTextField1!.backgroundColor = UIColor.whiteColor()
        passwordTextField1!.limitTextLength(12)
        
        // 年龄
        var img3 = UIImageView(image: UIImage(named: "锁zw"))
        img3.frame = CGRectMake(0, 0, 11, 16)
//        ageFiledText.leftView = img3
        ageFiledText.delegate=self
        ageFiledText!.leftViewMode = UITextFieldViewMode.Always
        ageFiledText!.layer.borderColor = UIColor.lightGrayColor().CGColor
        ageFiledText!.backgroundColor = UIColor.whiteColor()
        ageFiledText!.limitTextLength(2)
        
        
        sendBtn?.setTitleColor(UIColor(rgbByFFFFFF: 0x59bdef), forState: UIControlState.Normal)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getPwd:", name: "obtainPassword", object: nil)
        
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: "changeProtocolState")
        protocolImageView.addGestureRecognizer(tap)
        protocolImageView.userInteractionEnabled = true
        
        var maxDate = NSDate(daysBeforeNow: 365*18)
        ageChooseView.maxdate = maxDate
    }
    
    func changeProtocolState()
    {
        if protocolState == 0
        {
             protocolImageView.image = UIImage(named: "法律条规有勾")
            protocolState = 1
        }
        else
        {
            protocolImageView.image = UIImage(named: "法律条规无勾")
            protocolState = 0
        }
    }
    
    @IBAction func protocolAction(sender: AnyObject) {
//        var source = NSBundle.mainBundle().pathForResource("rule", ofType: "html")
//        var htmlString = String(contentsOfFile:source!, encoding: NSUTF8StringEncoding, error: nil)
        var webView = UIWebView()
        webView.loadRequest(NSURLRequest(URL: NSURL(string:XieYiURL)!))
        var vc=UIViewController()
        webView.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-64)
        vc.title="欲约通行证服务条款"
        vc.view.addSubview(webView)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendButtonClick(sender: AnyObject)
    {
        if telTextField!.text.isEmpty || telTextField!.text == ""
        {
            messageBox.showAlert("手机号不能为空")
            return()
        }
        else if (Int(count(telTextField!.text!)) !=  11)
        {
            messageBox.showAlert("您输入的手机号有误!")
            return()
        }
            //MARK: -- 发送验证码
        else if VerificatePhoneFormat.verificatePhoneFormat(telTextField!.text)
        {
            bufferInfoView.show(self.view)
            
            self.sendBtn?.startTimer()
            
            let tele=telTextField!.text
            let params = ["telephone": tele]
//            AFNetworkTool.postJSONWithUrl(CheckBindUsersURL, parameters: params, success: { (operation) -> Void in
//                var json: [String:AnyObject]? = NSJSONSerialization.JSONObjectWithData(operation.responseData!!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
//                var status:String? = json?["statusCode"] as? String
//                if status != "-1"
//                {
//                }
//                else
//                {
//                }
//                bufferInfoView.hiden()
//                }, fail: { (error) -> Void in
//                    bufferInfoView.hiden()
//            })
        }
        
    }
    var screenBounds = UIScreen.mainScreen().bounds
    
    @IBAction func nextButtonClick(sender: AnyObject)
    {
        verificationMessage()
    }
    
    func obtainInviteView()
    {
         bufferInfoView.show(self.view)
        var parameters = ["username":userName,"pwd":passwordTextField0?.text,"tel":telTextField.text,"pro":areaChooseView.province,"city":areaChooseView.city,"county":areaChooseView.region,"sex":sexChooseView.value=="男" ? "1":"0","qq":QQTextFiled.text,"age":ageFiledText.text,"mail":emailTextField.text.TrimAndLine()]
     
        AFNetworkTool.postJSONWithUrl(RegistURL, parameters: parameters, success: { (jsonData) -> Void in
            var dataArray = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as![String:AnyObject]
            var result = dataArray["res"] as! String
            if result == "1"
            {
//                messageBox.showAlert("注册成功!")
                UserInfo.login(dataArray["usernumber"] as! String, password: self.passwordTextField0!.text)
                UserInfo.completionBlock
                {
                    dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            var showNumVC = ShowNumberViewController()
                            showNumVC.number = UserInfo.UserNumber
                            self.navigationController?.pushViewController(showNumVC, animated: false)
                            
                        })
                    })
//                    var fireDate = NSDate(timeIntervalSinceNow: 1)
//                    var timer  = NSTimer(fireDate: fireDate, interval: 1, target: self, selector: "showNumberVC", userInfo: nil, repeats: false)
//                    NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
                }
            }
            else
            {
                 messageBox.showAlert(dataArray["msg"] as! String)
            }
            bufferInfoView.hiden(immediately: true)
            }) { (error) -> Void in
                messageBox.showAlert("请求超时。")
                bufferInfoView.hiden()
        }            
        
    }
    //MARK: -- 注册成功
    func registerNetworkRequest()
    {
        
    }
    //MARK: -- 验证信息
    func verificationMessage()
    {
        
        if(QQTextFiled!.text.isEmpty || QQTextFiled!.text == "")
        {
            messageBox.showAlert("QQ号不能为空")
            return()
        }
        else if(emailTextField!.text.isEmpty || emailTextField!.text == "")
        {
            messageBox.showAlert("邮箱号不能为空")
            return()
        }
        else if(!VerificatePhoneFormat.validateEmail(emailTextField!.text))
        {
            messageBox.showAlert("邮箱格式错误!")
            return()
        }
        else if !telTextField!.text.isEmpty && !VerificatePhoneFormat.verificatePhoneFormat(telTextField!.text)
        {
            messageBox.showAlert("您输入的手机号有误!")
            return()
        }
        else if(emailTextField!.text.isEmpty || emailTextField!.text == "")
        {
            messageBox.showAlert("邮箱不能为空")
            return()
        }
        else if !emailTextField!.text.TrimAndLine().isEmpty && !VerificatePhoneFormat.validateEmail(emailTextField!.text.TrimAndLine())
        {
            messageBox.showAlert("邮箱格式有误!")
            return()
        }
        else if (passwordTextField0!.text.isEmpty || passwordTextField0!.text == "")
        {
            messageBox.showAlert("密码不能为空!")
            return()
        }
        else if (passwordTextField1!.text.isEmpty || passwordTextField1!.text == "")
        {
            messageBox.showAlert("密码不能为空!")
            return()
        }
            
        else if (passwordTextField0!.text != passwordTextField1!.text)
        {
            messageBox.showAlert("密码不一致！")
            return()
        }
        else if(count(passwordTextField0!.text)<6)
        {
            messageBox.showAlert("密码长度不能少于6位!")
            return()
        }
        else if (ageFiledText!.text.isEmpty || ageFiledText!.text == "")
        {
            messageBox.showAlert("年龄不能为空!")
            return()
        }
        else if (ageFiledText!.text.toInt()<0 || ageFiledText!.text.toInt()>100 )
        {
            messageBox.showAlert("年龄范围为0˜100!")
            return()
        }
        else if areaChooseView.region.isEmpty || areaChooseView.region == "区域"
        {
            messageBox.showAlert("地区不能为空。")
            return()
        }
        else if protocolState == 0
        {
            messageBox.showAlert("同意欲约通行证服务条款方可注册")
            return()
        }
        else
        {
            obtainInviteView()
        }
    }
    
    //MARK: -- 注册成功
    func userBaseInfomation(token:String,userId:Int)
    {
        
        
    }
    func hidenKeyBord()
    {
        self.view.endEditing(true)
    }
    
    override func  touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
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
    
    func getPwd(notification:NSNotification)
    {
        
    }
    func push()
    {
        registerNetworkRequest()
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        MobClick.beginLogPageView("RegisterViewController")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        MobClick.endLogPageView("RegisterViewController")
    }
    
    
}
