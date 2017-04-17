//
//  MD5Util.swift
//  E_Education
//
//  Created by admin on 14-9-2.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//


class MD5Util: NSObject {
   class func md5HexDigest(input:String)->String{
    var data=(input as NSString).UTF8String
    
    var result:[UInt8]=[UInt8](count:16, repeatedValue: 0)
    CC_MD5(data,CC_LONG(count(input)), &result)
    var value:NSMutableString=""
    for i:Int in 0...15{
        value.appendFormat("%02x", result[i])
    }
    return value as String
    }


}
