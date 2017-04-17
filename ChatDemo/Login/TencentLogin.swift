//
//  TencentLogin.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class TencentLogin: ThirdParyLogin,TencentLoginDelegate,TencentSessionDelegate {
    // 单例
    private struct instance {
        static var instance=TencentLogin()
    }
    private lazy var api:TencentOAuth=TencentOAuth(appId: "1103377550", andDelegate:
        instance.instance)
 
    // QQ 登录
    class func login(){
        var permissions = NSMutableArray(objects: kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_USER_INFO)
        instance.instance.api.authorize(permissions as [AnyObject])
    }
    override func type() -> String! {
        return "qq"
    }
    // QQ 登录成功
    internal func tencentDidLogin()
    {
        bind(api.openId)    
    }
    // QQ 取消登录
    internal func tencentDidNotLogin(cancelled:Bool)
    {
        
        if (cancelled)
        {
            alert.text = "用户取消登录"
            alert.showAlert()
        }
        else
        {
            alert.text = "登录失败"
            alert.showAlert()
        }
    }
    internal func tencentDidNotNetWork()
    {
        alert.text = "无网络连接，请设置网络"
        alert.showAlert()
    }
    

}
