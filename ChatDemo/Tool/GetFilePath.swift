//
//  GetFilePath.swift
//  CardTableView
//
//  Created by admin on 15-3-23.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

import UIKit

class GetFilePath: NSObject {
    /**
    获取与某个人聊天的会话文件
    
    :param: name 聊天对象
    
    :returns: 返回与该聊天人的会话纪录文件地址
    */
    class func getFilePath(name:String)->String
    {
        var path = "Documents/" +  "/" + name + "." + UserInfo.userID
        return NSHomeDirectory().stringByAppendingPathComponent(path)
    }
    /**
    获取所有浏览过人的用户资料路径
    
    :returns: 返回所有浏览过人的用户资料路径
    */
    class func getUserDateListPath()->String
    {
        var path = "Documents/"  + "/allUserDataList" + "." + UserInfo.userID
        return NSHomeDirectory().stringByAppendingPathComponent(path)
    }
    /**
    获取所有浏览过人的用户图片路径
    
    :returns: 返回所有浏览过人的用户图片路径
    */
    class func getUserImageListPath()->String
    {
        var path = "Documents/"  + "/allUserImageList" + "." + UserInfo.userID
        return NSHomeDirectory().stringByAppendingPathComponent(path)
    }
    /**
    获取好友申请信息保存的缓存路径
    
    :returns: 返回好友申请信息保存的缓存路径
    */
    class func getFriendAskListPath()->String
    {
        var path = "Documents/"  + "/allFriendAsk" + "." + UserInfo.userID
        return NSHomeDirectory().stringByAppendingPathComponent(path)
    }
    /**
    获取黑名单的缓存路径
    
    :returns: 返回黑名单的缓存路径
    */
    class func getBlackListPath()->String
    {
        var path = "Documents/"  + "/blacklist" + "." + UserInfo.userID
        return NSHomeDirectory().stringByAppendingPathComponent(path)
    }
    
    class func hasFile(filePath:String) -> Bool
    {
        // 获取本地所有缓存信息
        var fileManager = NSFileManager.defaultManager()
        
        // 判断沙盒中有没有一个保存与该用户聊天数据的缓存文件
        // 如果有的话  就根据文件的内容去初始化数组
        if fileManager.fileExistsAtPath(filePath)
        {
            return true
        }
        else
        {
            return false
        }
    }
}
