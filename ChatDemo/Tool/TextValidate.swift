//
//  TextValidate.swift
//  TextValidation
//
//  Created by user on 15/6/1.
//  Copyright (c) 2015年 user. All rights reserved.
//
import UIKit

class TextValidate: NSObject {
    //替换非法字符
   class func repIllegalChar(string:NSString) -> NSString
    {
        var rangex:NSRegularExpression = NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        var modifiedString = rangex.stringByReplacingMatchesInString(string as String, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, string.length), withTemplate: "")
        return modifiedString
    }
    //验证表情
   class func valiExpression(string:NSString) -> Bool
    {
        var isEomji = false
        string.enumerateSubstringsInRange(NSMakeRange(0, string.length), options: NSStringEnumerationOptions.ByComposedCharacterSequences)
            { (substring,substringRange,enclosingRange,stop) -> Void in
                var hs:unichar = (substring as NSString).characterAtIndex(0)
                if 0xd800 <= hs && hs <= 0xdbff {
                    if (substring as NSString).length > 1 {
                        var ls:unichar = (substring as NSString).characterAtIndex(1)
                        var uc:NSInteger = ((NSInteger(hs) - 0xd800) * 0x400) + (NSInteger(ls) - 0xdc00) + 0x10000
                        if 0x1d000 <= uc && uc <= 0x1f77f {
                            isEomji = true;
                        }
                        isEomji = true;
                    }
                }
                else if (substring as NSString).length > 1 {
                    var ls:unichar = (substring as NSString).characterAtIndex(1)
                    if ls == 0x20e3 || ls == 0xfe0f {
                        isEomji = true;
                    }
                }
                else {
                    if 0x2100 <= hs && hs <= 0x27ff && hs != 0x263b && hs > 10130 && hs < 10123 {
                        isEomji = true;
                    } else if 0x2B05 <= hs && hs <= 0x2b07 {
                        isEomji = true;
                    } else if 0x2934 <= hs && hs <= 0x2935 {
                        isEomji = true;
                    } else if 0x3297 <= hs && hs <= 0x3299 {
                        isEomji = true;
                    } else if hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c  || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a  {
                        isEomji = true;
                    }
                }
            }
        return isEomji
    }
    //验证长度
   class func validStringLength(string:NSString,lenght:Int) -> Bool
    {
        var isMt = false
        if string.length > lenght
        {
        isMt = true
        }
        return isMt
    }
    //验证是否纯数字
   class func validNumber(string:NSString) -> Bool
    {
        var regex:String = "^[0-9]*$"
        return validreg(regex,str: string as String)
        
    }
    //验证是否手机号
   class func validPhoneNumber(string:String) -> Bool
    {
        var regex:String = "^1\\d{10}$"
        return validreg(regex,str: string)
    }
    //验证是否电话号
   class func validTelNumber(string:String) -> Bool
    {
        var regex:String = "^[0-9]+([-]\\d+)?$"
        return validreg(regex,str: string)
    }
    
    private class func validreg(regex:String,str:String)->Bool
    {
        var telPred:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return telPred.evaluateWithObject(str)
    }
}
