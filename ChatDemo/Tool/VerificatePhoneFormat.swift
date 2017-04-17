//
//  VerificatePhoneFormat.swift
//  E_Education
//
//  Created by admin on 15-1-28.
//  Copyright (c) 2015年 TFQ. All rights reserved.
//

import UIKit
class VerificatePhoneFormat: NSObject
{
    
    /**
    验证手机号码
    
    :param: string 手机号码字符串
    
    :returns: 真假
    */
    class func verificatePhoneFormat(string:String)->Bool
    {
        
        var regex:String = "^1\\d{10}$"
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        var res:Bool = telPred.evaluateWithObject(string)
//        if !res
//        {
//            messageBox.showAlert("手机格式不正确!")
//        }
        return res
    }
    
    // 表情符号转换成字符串
    class func disable_emoji(text:NSString)->Bool
    {
        var rangex:NSRegularExpression = NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        var modifiedString = rangex.stringByReplacingMatchesInString(text as String, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, text.length), withTemplate: "")
        return (modifiedString as NSString).length==text.length
    }
    
    /**
    验证邮箱
    */
    class func validateEmail(string:String)->Bool
    {
        
        var regex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        var res:Bool = telPred.evaluateWithObject(string)
        if !res
        {
            messageBox.showAlert("邮箱格式不正确!")
        }
        return res
    }
    /**
    验证电话号码
    */
    class func verificateTelphone(string:String)->Bool
    {
        var regex:String = "^[0-9]+([-]\\d+)?$"
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        var res = telPred.evaluateWithObject(string) || (string == "" || string.isEmpty)
        if !res
        {
             messageBox.showAlert("电话格式不正确!")
        }
        return res
    }
    /**
    验证是否是纯数字
    */
    class func verificateNumber(string:String)->Bool
    {
        var regex:String = "\\d+"
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        var res = telPred.evaluateWithObject(string)
        return res
    }
    /**
    验证环信命名规则
    
    :param: userName 用户名
    
    :returns: 返回真假
    */
     class func verificateUserName(userName:String)->Bool
     {
        var regex:String = "[a-zA-Z0-9_\\-.]*"
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        var res = telPred.evaluateWithObject(userName)
        if !res
        {
            messageBox.showAlert("用户名格式不正确!")
        }
        return res
     }
    /**
    验证字符串是否符合规则
    
    :param: format 规则字符串
    :param: string 被规则字符串
    
    :returns: 返回真假
    */
    class func verificateString(format:String,string:String)->Bool
    {
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", format)
        var res = telPred.evaluateWithObject(string)
        if !res
        {
//            messageBox.showAlert("格式不正确!")
        }
        return res
    }
   
}
