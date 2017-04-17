//
//  ThirdParyLogin.swift
//  E_Education
//
//  Created by admin on 14-10-29.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class ThirdParyLogin: NSObject{
    var alert=TFQAlertUtil()
    internal func type()->String!{
          return nil
    }
    private func openIdField()->String!{
        return type()+"OpenId"
    }
    internal func bind(openId:String){
        if UserInfo.isLogin
        {
            let params = ["userId": UserInfo.userInfo!["userId"]! as! NSNumber, openIdField(): openId]
            AFNetworkTool.postJSONWithUrl(LoginCheckBindUsers, parameters: params, success: { (responseObject) -> Void in
                var json: [String:AnyObject]? = NSJSONSerialization.JSONObjectWithData(responseObject.responseData!!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
                var statusCode = json!["statusCode"] as! String?
                if statusCode ==  "0"
                {
                    self.alert.text = "第三方账号已有绑定用户"
                    self.alert.showAlert()
                }
                else
                {
                    self.alert.text = "绑定成功"
                    self.alert.showAlert()
                }

            }, fail: { (error) -> Void in
                println("Error: " + error.localizedDescription)
            })

        }
        else
        {
            let params = [openIdField(): openId]
//            AFNetworkTool.postJSONWithUrl(CheckBindUsersURL, parameters: params, success: { (responseObject) -> Void in
//                var json: [String:AnyObject]? = NSJSONSerialization.JSONObjectWithData(responseObject.responseData!!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
//                var status = json!["statusCode"] as! String?
//                if status == "0"
//                {
//                    var bindVC = BindViewController()
//                    bindVC.openId=(openId,self.type())
//                    navigationController().pushViewController(bindVC, animated: true)
//                }
//                else
//                {
//                    UserInfo.userInfo=json! as [String:AnyObject]
//                    // 直接登录
//                    NSUserDefaults.standardUserDefaults().setObject(UserInfo.userInfo, forKey: ChatDemoUser)
//                    navigationController().popToRootViewControllerAnimated(true)
//                }
//                
//                }, fail: { (error) -> Void in
//                    println("Error: " + error.localizedDescription)
//            })

        }

    }
   
}
