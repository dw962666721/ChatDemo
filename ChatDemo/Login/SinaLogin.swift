//
//  SinaLogin.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class SinaLogin: ThirdParyLogin,WBHttpRequestDelegate,WeiboSDKDelegate {
    // 单例
    private struct instance {
        static var instance=SinaLogin()
    }

    class func shareInstance()->SinaLogin{
        return instance.instance
    }
    // Weibo登录
    class func login() {
        var request:WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = kRedirectURL
        request.scope = "all"
        
        request.userInfo = ["SSO_From": " ",
            "Other_Info_1": NSNumber(int: 123),
            "Other_Info_2": ["obj1", "obj2"],
            "Other_Info_3": [["key1": "obj1", "key2": "obj2"]]]
        WeiboSDK.sendRequest(request)
        
    }
    override func type() -> String! {
        return "sina"
    }
    // Weibo登录完成回调
    internal func didReceiveWeiboResponse(response: WBBaseResponse!)
    {
        var respon:WBAuthorizeResponse = response as! WBAuthorizeResponse
        if respon.userID != nil{
            bind( MD5Util.md5HexDigest(respon.userID+"deshell"))
        }
    }
    internal func didReceiveWeiboRequest(request: WBBaseRequest!)
    {
        
    }
    internal func request(request: WBHttpRequest!, didFinishLoadingWithResult result: String!)
    {
        
    }
    internal func request(request: WBHttpRequest!, didFailWithError error: NSError!)
    {
    }
}
