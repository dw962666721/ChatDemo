//
//  UserUtil.swift
//  E_Education
//
//  Created by admin on 14-9-10.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//
class UserInfoForObjc:NSObject{
    static var userInfo = UserInfo.userInfo
    class func userId()->String{
        return UserInfo.userInfo?["userid"] as! String!
    }
    class func UserNumber()->String{
        if (UserInfo.userInfo?["usernumber"] != nil)
        {
            return UserInfo.userInfo?["usernumber"] as! String!
        }
        return ""
    }
    class func passWord()->String{
        return UserInfo.userInfo?["passWord"] as! String!
    }
    class func isLogin()->Bool {
        return UserInfo.userInfo != nil
    }
    class func loginHX() {
        UserInfo.loginHX()
    }
    class func refresh() {
        UserInfo.refresh()
    }
}

struct UserInfo {
    static  let UserTypeTeacher = 1;
    static  let UserTypeStudent = 0;
    static  let UserTypeVisitor = -1;
    static var CopyAvatar:String!;
    static var userType:Int{
        get{
        var temp:Int! = (userInfo?["userType"] as? String)?.toInt()
        return temp != nil ? temp : UserTypeVisitor
        }
        set
    {
        
        var userInfo=UserInfo.userInfo
        userInfo?["userType"]="\(newValue)"
        UserInfo.userInfo=userInfo
        }
    }
    
    static var userInfo:[String:AnyObject]? = NSUserDefaults.standardUserDefaults().objectForKey(ChatDemoUser) as? [String:AnyObject]
    static func save()
    {
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: ChatDemoUser)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    /// 我爱账号
    static var UserNumber:String!{
        get{
            var usernumber=userInfo?["usernumber"] as! String!
            return usernumber
        }
    }
    /// 头像地址
    static var userAvatar:String!{
        get{
            var avatarUrl=userInfo?["avatar"] as! String!
            return ServerURL + "\(avatarUrl)"
        }
    }
    /// 年龄
    static var Age:Int!{
        get{
            if (userInfo!["age"] == nil || userInfo!["age"] as! String == "")
            {
                return -1
            }
            var age=(userInfo!["age"] as! String).toInt()
            return age
        }
    }
    /// 邮箱账号
    static var Email:String!{
        get{
        var mail=userInfo?["mail"] as! String!
        return mail
        }
        set
    {
        userInfo?["mail"] = newValue
        }
    }
    /// QQ账号
    static var QQ:String!{
        get{
            var qq=userInfo?["qq"] as! String!
            return qq
        }
        set
    {
        userInfo?["qq"] = newValue
        }
    }
    /// 手机号码
    static var Tel:String!{
        get{
            if (userInfo?["tel"] == nil)
            {
                return ""
            }
            var tel=userInfo?["tel"] as! String!
            return tel
        }
        set
    {
         userInfo?["tel"] = newValue
        }
    }
    /// 省份
    static var ProName:String!{
        get{
            var pro=userInfo?["pro"] as! String!
            return pro
        }
    }
    /// 城市
    static var City:String!{
        get{
            var city=userInfo?["city"] as! String!
            return city
        }
    }
    /// 区域
    static var County:String!{
        get{
            var county=userInfo?["county"] as! String!
            return county
        }
    }
    /// 备注
    static var Mark:String!{
        get{
            var mark=userInfo?["mark"] as! String!
            return mark
        }
    }
    /// 身材
    static var Figure:String!{
        get{
            var figure=userInfo?["figure"] as! String!
            return figure
        }
    }
    /// 会员名称
    static var VipName:String!{
        get{
            var memberlevel=userInfo?["memberlevel"] as! String!
            return memberlevel
        }
    }

    /// 会员
    static var IsVip:Bool{
        get{
            var memberlevel=userInfo?["memberlevel"] as! String!
            return memberlevel != "普通会员"
        }
        set
        {
            userInfo?["memberlevel"] = "至尊会员"
            save()
        }
    }
    
    /// 会员到期时间
    static var MemberendDate:String{
        get{
            var memberenddate=userInfo?["memberenddate"] as! String!
            return memberenddate
        }
        set
        {
            userInfo?["memberenddate"] = newValue
        }
    }
    /// 头像地址
    static var userAvatarUrl:NSURL!{
        get{
            var avatarUrl=userInfo?["avatar"] as! NSString!
            return NSURL(string: ServerURL + "\(avatarUrl)")
        }
    }
    ///  是否登陆
    static var isLogin:Bool{
        get{
            
            return UserInfo.userInfo != nil
        }
    }
    /// 用户id 也是环信账号
    static var userID:String!{
        get{
            return UserInfo.userInfo?["userid"] as? String
        }
    }
    /// 密码
    static var passWord:String!{
        get{
            return UserInfo.userInfo?["passWord"] as? String
        }
    }
    /// 用户名
    static var userName:String!{
        get{
            return UserInfo.userInfo?["username"] as? String
        }
        set
    {    
        userInfo?["username"] = newValue
        NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: ChatDemoUser)
        NSUserDefaults.standardUserDefaults().synchronize()

        }
    }
    /// 真实姓名
    static var TrueName:String!{
        get{
            return (UserInfo.userInfo?["truename"] as? String == ""||UserInfo.userInfo?["truename"] as? String == nil) ? userName : UserInfo.userInfo?["truename"] as? String
        }
        set
        {
            userInfo?["truename"] = newValue
            NSUserDefaults.standardUserDefaults().setObject(userInfo, forKey: ChatDemoUser)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    /// 性别
    static var Sex:String!{
        get{
            return (UserInfo.userInfo?["sex"] as? String == "1") ? "男" : "女"
        }
    }
    static var complantBlock : (()->())!
    static func completionBlock(completionBlock:(()->()))
    {
        complantBlock = completionBlock
    }
    /**
    登录
    */
    static func login(name:String,password:String){
        var parameters : [String:AnyObject] = ["username":name,"pwd":password]
        
        AFNetworkTool.postJSONWithUrl(LoginURL, parameters: parameters, success: { (jsonObject) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonObject as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            var result = json["res"] as! String
            if result == "1"
            {
                self.dealResult(json,password: password)
//                NSNotificationCenter.defaultCenter().postNotificationName("UserLogin", object: nil, userInfo: nil)
                if (self.complantBlock != nil)
                {
                    self.complantBlock()
                }
            }
            else
            {
                messageBox.text = json["msg"] as! String
                messageBox.showAlert()
            }
            }) { (error) -> Void in
                messageBox.showAlert()
        }
        
    }
    /**
    登陆环信
    */
    static func loginHX()
    {
        var isAutoLogin = EaseMob.sharedInstance().chatManager.isAutoLoginEnabled!
        if (!isAutoLogin) {
            EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(UserInfo.UserNumber, password: UserInfo.passWord, completion: {
                (loginInfo,error) -> Void in
                if ((error == nil) && (loginInfo != nil)) {
                    // 设置自动登录
                    (UIApplication.sharedApplication().delegate as! AppDelegate).setAutoLogin()
                    NSNotificationCenter .defaultCenter() .postNotificationName("loadChatList", object: nil);
                }
                }, onQueue: nil)
        }
    }
    static func dealResult(dict:NSDictionary,password:String)
    {
        var json: [String:AnyObject] = dict as! [String : AnyObject]
        //        json["userName"] = dict["user_account"]
        json["passWord"] = password
        UserInfo.userInfo = json
        NSUserDefaults.standardUserDefaults().setObject(json, forKey: ChatDemoUser)
        NSUserDefaults.standardUserDefaults().synchronize()
        loginHX()
    }
    
    static func refresh(){
        if UserInfo.isLogin{
            var passWord = UserInfo.passWord
            let params = ["username": UserInfo.UserNumber, "pwd": passWord]
            AFNetworkTool.postJSONWithUrl(LoginURL, parameters: params, success: { (jsData) -> Void in
                var data = NSJSONSerialization.JSONObjectWithData(jsData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
//                println(data)
                var result = data["res"] as! String
                if result == "1"
                {
                    data["passWord"] = passWord
                    UserInfo.userInfo = data
                    NSUserDefaults.standardUserDefaults().setValue(data, forKey: ChatDemoUser)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    UserInfo.loginHX()                    
                }
                else
                {
                    NSUserDefaults.standardUserDefaults().removeObjectForKey(ChatDemoUser)
                    messageBox.showAlert("连接服务器失败")
                    NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView0", object: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView1", object: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView2", object: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("toLoginAndRegistView3", object: nil)
                }
                }, fail: { (error) -> Void in
                    messageBox.showAlert("连接服务器失败")
            })
//            manager.responseSerializer.acceptableContentTypes =  sets.setByAddingObject(getType)
//
//            manager.GET(ServerURL+"refreshUsers.jspx",
//                parameters: params,
//                success: { (operation: AFHTTPRequestOperation!,
//                    responseObject: AnyObject!) in
//                    var json: [String:AnyObject]? = NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as?[String:AnyObject]
//                    // 登录成功
//                    if(json != nil)
//                    {
//                        NSUserDefaults.standardUserDefaults().setObject(json!, forKey: ChatDemoUser)
//                        UserInfo.userInfo=json
//                    }
//                },
//                failure: { (operation: AFHTTPRequestOperation!,
//                    error: NSError!) in
//            })
        }
    }
}
