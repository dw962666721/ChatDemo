//
//  PersonalHomepageViewController.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//


class MyUIView: UIView{

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        var touch:UITouch = touches.first as! UITouch
        var point:CGPoint = touch.locationInView(self)
        self.backgroundColor = UIColor.grayColor()
        self.alpha = 0.7
    }
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!)
    {
        self.backgroundColor = UIColor.whiteColor()
        self.alpha = 1
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.alpha = 1
        self.backgroundColor = UIColor.whiteColor()
    }
    
}
class PersonalHomePageViewController: UIViewController,UIAlertViewDelegate,TFQPullViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HandleUploadPhotosDelegate{
    
    @IBOutlet weak var informationBtn: UIButton!
    @IBOutlet weak var usertitleLabel: UILabel!
    @IBOutlet weak var userNumbelLabel: UILabel!
    @IBOutlet weak var bgScrollView: UIScrollView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var bgImgView: UIImageView!
    
    
    @IBOutlet weak var defaultImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var myCollectImgView: UIImageView!

    @IBOutlet weak var myCollectLabel: UILabel!
    @IBOutlet weak var myCollectBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var aboutUSImgView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var aboutUSLabel: UILabel!
    @IBOutlet weak var detectionOfUpdateLabel: UILabel!
    

    
    @IBOutlet weak var thirdBandingBtn: UIButton!
    
    @IBOutlet weak var settingBtn: UIButton!
    
    
    @IBOutlet weak var editAvatarBtn: UIButton!
    @IBOutlet weak var aboutUsBtn: UIButton!
    
//    @IBOutlet weak var memberViewBConstraint: NSLayoutConstraint!
    var alert:TFQAlertUtil=TFQAlertUtil()
    
    
    lazy var headerView:UIView={
        var view:UIView=UIView(frame: CGRectMake(0, 0, screenWidth, 20))
        view.backgroundColor=UIColor.whiteColor()
        return view
        }()
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if UserInfo.isLogin
        {
            loadData()
            
        }else {
            showUnLoginStates()
        }
     
        MobClick.beginLogPageView("PersonalHomePageViewController")
    }
    override func viewDidLoad() {
        
       // rightBarButtonItem()
        super.viewDidLoad()
       
        NSBundle.mainBundle().loadNibNamed("PersonalHomePageViewController", owner: self, options: nil)[0]
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "toLoginAndRegistView", name: "toLoginAndRegistView3", object: nil)
        
        self.navigationItem.title = "个人主页"
        
        UserInfo.refresh()
        
        setStyle()
        
        addRefresh()
        
        addGestureRecognizer()
    }
    func addGestureRecognizer()
    {
        var tap1 = UITapGestureRecognizer(target: self, action: "editInformation")
        tap1.numberOfTapsRequired = 1
        tap1.numberOfTouchesRequired = 1
        headView.addGestureRecognizer(tap1)
        
        var tap2 = UITapGestureRecognizer(target: self, action: "changeImage")
        tap2.numberOfTapsRequired = 1
        tap2.numberOfTouchesRequired = 1
        defaultImgView.addGestureRecognizer(tap2)
        
    }
    
    func addRefresh()
    {
        var heard = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadData")
        bgScrollView.header = heard
        heard.backgroundColor = UIColor.blackColor()
        bgScrollView.backgroundColor = UIColor.blackColor()
        heard.stateLabel.textColor = UIColor.whiteColor()
        heard.lastUpdatedTimeLabel.textColor = UIColor.whiteColor()
    }
    func setStyle()
    {
        self.view.backgroundColor = UIColor.yellowColor()
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf0f0f0)
        
//        if UserInfo.IsVip
//        {
//            memberViewBConstraint.constant = -44
//        }
//        else
//        {
//            memberViewBConstraint.constant = 10
//        }
        
        defaultImgView.layer.masksToBounds = true
        defaultImgView.layer.cornerRadius = 2
        
        informationBtn.layer.masksToBounds = true
        informationBtn.layer.cornerRadius = 5
        informationBtn.layer.borderColor = UIColor.grayColor().CGColor
        informationBtn.layer.borderWidth=1
        
        headView.backgroundColor = UIColor(rgbByFFFFFF: 0xf0f0f0)
        bgScrollView.delegate = self
        
        
        UserInfo.isLogin ? loadData() : showUnLoginStates()
        
        middleView.layer.borderWidth=1
        middleView.layer.borderColor=UIColor(rgbByFFFFFF: 0xF0F0F0).CGColor
        bottomView.layer.borderWidth=1
        bottomView.layer.borderColor=UIColor(rgbByFFFFFF: 0xF0F0F0).CGColor
        
        lineView.layer.borderColor=UIColor(rgbByFFFFFF: 0xF0F0F0).CGColor
        
        myCollectBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.87*screenWidth, bottom: 0, right: 0)
        
        thirdBandingBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.87*screenWidth, bottom: 0, right: 0)
        
        settingBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.87*screenWidth, bottom: 0, right: 0)
        
        aboutUsBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.87*screenWidth, bottom: 0, right: 0)
        editAvatarBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.87*screenWidth, bottom: 0, right: 0)
    }
    /**
    修改资料
    */
    func editInformation()
    {
        var vc = EditInformationViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.userId = UserInfo.userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func changeImage()
    {
        HandleUploadPhotos.photoPicker(currentViewController: self, delegate: self,allowsEditing: true)
    }
    func imagePickerControllerDidFinishPickingMediaWithInfo(image: UIImage) {
        dealImage(image)
    }
    func imagePickerControllerDidCancel() {
        
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0
        {
            return
        }
        else
        {
            var picker = UIImagePickerController()
            var sourceType = UIImagePickerControllerSourceType.Camera
            if buttonIndex == 2
            {
                sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            picker.sourceType = sourceType
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func dealImage(image:UIImage)
    {
        //上传图片
        var parameters = ["userid":UserInfo.userID,"type":"png"]
        bufferInfoView.show(self.view)
        AFNetworkTool.postUploadWithData(UpdateMyavatarURL, parameters: parameters, fileData: UIImagePNGRepresentation(image), filename: "img", success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
            var result = json!["res"] as! String
            if result == "1"
            {
                var icoUrl = json!["msg"] as! String
                var dict = UserInfo.userInfo!
                dict["avatar"] = icoUrl
                UserInfo.userInfo = dict
                NSUserDefaults.standardUserDefaults().setObject(dict, forKey: ChatDemoUser)
                NSUserDefaults.standardUserDefaults().synchronize()
                self.defaultImgView.image = image
                messageBox.showAlert("上传成功！")
                bufferInfoView.hiden()
                
                SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: ServerURL+icoUrl), options: SDWebImageOptions.allZeros, progress: { (aa, bb) -> Void in
                    
                }, completed: { (image, error, SDImageCacheType, bo, url) -> Void in
                    
                })
            }
            else
            {
                messageBox.text = json!["msg"] as! String
                messageBox.showAlert()
                bufferInfoView.hiden()
            }
            
            }, fail: { () -> Void in
                messageBox.text = "上传头像失败"
                messageBox.showAlert()
                bufferInfoView.hiden()
        })
        
    }
    func rightBarButtonItem()
    {
            self.navigationItem.setRightBarButtonItems([UIBarButtonItem.barButtonItemWithWidth(-25),UIBarButtonItem.barButtonItemWithTitle("注册/登录", target: self, action: "loginBtnClick")], animated: false)
    }
    
    func loadData(){
        if UserInfo.isLogin
        {
            defaultImgView.sd_setImageWithURL(UserInfo.userAvatarUrl,placeholderImage: UIImage(named: "logo"))
            titleLabel.text = UserInfo.TrueName
            userNumbelLabel.text = UserInfo.UserNumber
            usertitleLabel.hidden = false
            titleLabel.hidden = false
            userNumbelLabel.hidden = false
        }
        
        if (bgScrollView.header != nil)
        {
            bgScrollView.header.endRefreshing()
        }
    }
    func viewDidPulledTrigger(pullView: TFQPullView!, type: TFQPullType)
    {
        if UserInfo.isLogin == true
        {
            UserInfo.refresh()
            loadData()

            var newMsgCount = UserInfo.userInfo?["newMsg"] as? NSNumber
            var valueFlag:Bool!
            if newMsgCount == nil || newMsgCount == 0
            {
                valueFlag = false
            }
            else
            {
                valueFlag = true
            }
            
            var dic = NSDictionary(dictionary: ["flag":valueFlag])
        NSNotificationCenter.defaultCenter().postNotificationName("changeRedDotStatesNotification", object: dic)
        }
    }

    @IBAction func handleBindingAccountBtnClick(sender: AnyObject)
    {
        var safeVC = SafecenterViewController()
        safeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(safeVC, animated: true)
    }
    /**
    会员充值
    */
    @IBAction func handleMyCollectBtnClick(sender: AnyObject)
    {
        var vc:UIViewController!
        if UserInfo.isLogin
        {
            vc = ChooseVipViewController()
        }
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    /**
    关于我们
    */
    @IBAction func handleAboutUSBtnClick(sender: AnyObject)
    {
//        var source = NSBundle.mainBundle().pathForResource("rule", ofType: "html")
//        var htmlString = String(contentsOfFile:source!, encoding: NSUTF8StringEncoding, error: nil)
        var webView = UIWebView()
        webView.loadRequest(NSURLRequest(URL: NSURL(string:XieYiURL)!))
        var vc=UIViewController()
        webView.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-64)
        vc.title="用户协议"
        vc.view.addSubview(webView)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**
    修改头像
    */
    @IBAction func handelEditAvatar(sender: AnyObject) {
        changeImage()
    }
    
    @IBAction func outLoginAction(sender: AnyObject) {
        handleCancelUserBtnClick()
    }
    func handleCancelUserBtnClick()
    {
        var alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "您确定要注销吗?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定") as UIAlertView
        alertView.show()
      
        
        
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
             if(buttonIndex == 0)
            {
                return
            }
            else
            {
                logout()
            }
    }
    private func logout()
    {
        bufferInfoView.show(self.view)
        //注销环信
        EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true, completion:
            {(info,error) -> Void in
                if error == nil
                {
                    bufferInfoView.hiden()
                    UserInfo.userInfo=nil
                    // 退出登录 注销登录信息
                    NSUserDefaults.standardUserDefaults().removeObjectForKey(ChatDemoUser)
                    NSUserDefaults.standardUserDefaults().synchronize()
//                    UserInfo.save()
                    self.showUnLoginStates()
                    self.toLoginAndRegistView()
                }
                else
                {
                    messageBox.showAlert("退出 都没退出成功。。。。。")
                }
                bufferInfoView.hiden()
            }, onQueue: nil)
    }

    func toLoginAndRegistView()
    {
        if !UserInfo.isLogin
        {
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var guidanceVC = LoginAndRegistViewController()
                    guidanceVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(guidanceVC, animated: false)
                })
            })
        }
    }
    
    // 未登录状态
    func showUnLoginStates(){
        titleLabel.text="未登录"
        userNumbelLabel.hidden = true
        usertitleLabel.hidden = true
        toLoginAndRegistView()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        MobClick.endLogPageView("PersonalHomePageViewController")
    }

          override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

