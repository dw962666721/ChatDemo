//
//  PropertyController.swift
//  ChatDemo
//
//  Created by user on 15/8/19.
//  Copyright (c) 2015年 user. All rights reserved.
//

import Foundation

 class PropertyController:NSObject {
    static func setmessageBox(messagebox:TFQAlertUtil)
    {
        messageBox = messagebox
    }
    static func MessageBox()->TFQAlertUtil
    {
       return messageBox
    }
    
    static func setBufferView(bufferView:BufferView)
    {
        bufferInfoView = bufferView
    }
    static func BufferInfoView()->BufferView
    {
        return bufferInfoView
    }
    static func insertUserImageList(userid:String,imageListData:[[String:AnyObject]])
    {
        var arrary : NSMutableArray = []
        if GetFilePath.hasFile(GetFilePath.getUserImageListPath())
        {
            arrary = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getUserImageListPath()) as! NSMutableArray
        }
        var hasData = false
        for var i = 0 ;i<arrary.count;i++
        {
            var dataItem = arrary[i] as! [String:AnyObject]
            if dataItem["userid"] as! String == userid
            {
                dataItem["value"] = imageListData
                arrary[i] = ["userid":userid,"value":imageListData]
                hasData = true
                break
            }
            
        }
        if !hasData
        {
            arrary.addObject(["userid":userid,"value":imageListData])
        }
        
        NSKeyedArchiver.archiveRootObject(arrary, toFile: GetFilePath.getUserImageListPath())
    }
    static func getUserImageList(userid:String)->[[String:AnyObject]]
    {
        var arrary : NSMutableArray = []
        if GetFilePath.hasFile(GetFilePath.getUserImageListPath())
        {
            arrary = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getUserImageListPath()) as! NSMutableArray
        }
        var hasData = false
        for var i = 0 ;i<arrary.count;i++
        {
            var dataItem = arrary[i] as! [String:AnyObject]
            if dataItem["userid"] as! String == userid
            {
                return  dataItem["value"] as! [[String:AnyObject]]
            }
            
        }
        return []
    }
    static func getUserName(conversation:EMConversation)->String
    {
        var result = getNameByUserNumber(conversation.chatter)
//        var lastMessage = conversation.latestMessage()
//        if (lastMessage != nil)
//        {
//            var ext = lastMessage.ext
//            if (ext != nil)
//            {
//                if ((ext!.indexForKey("userNumber")) != nil)
//                {
//                    var key = "name"
//                    if conversation.chatter != ext["userNumber"] as? String
//                    {
//                        key += "0"
//                    }
//                    if ((ext!.indexForKey(key)) != nil)
//                    {
//                        result = ext![key] as! String
//                    }
//                }
//            }
//            if (ext != nil)
//            {
//                if ((ext!.indexForKey("name0")) != nil)
//                {
//                    result = ext!["name0"] as! String
//                }
//            }
//        }
        return result
    }
    
    static func getUserAvatar(conversation:EMConversation)->String
    {
        var result = getAvatarByNumber(conversation.chatter)
//        var lastMessage = conversation.latestMessage()
//        if (lastMessage != nil)
//        {
//            var ext = lastMessage.ext
//            if (ext != nil)
//            {
//                 if ((ext!.indexForKey("userNumber")) != nil)
//                 {
//                    var key = "avatar"
//                    if conversation.chatter != ext["userNumber"] as? String
//                    {
//                        key += "0"
//                    }
//                    if ((ext!.indexForKey(key)) != nil)
//                    {
//                        result = ext![key] as! String
//                    }
//                }
//            }
//        }
        return result
    }
    
    static func getNameById(userId:String)->String
    {
        var result = userId
        var path = GetFilePath.getUserDateListPath()
        if GetFilePath.hasFile(path)
        {
            var allUserDataList = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
            for userData in allUserDataList
            {
                if userData["userid"] as! String == userId
                {
                    if (userData["truename"] as! String).isEmpty
                    {
                        result = userData["username"] as! String
                    }
                    else
                    {
                        result = userData["truename"] as! String
                    }
                }
            }
        }
        return result
    }
    static func getNameByUserNumber(userNumber:String)->String
    {
        var result = userNumber
        var path = GetFilePath.getUserDateListPath()
        if GetFilePath.hasFile(path)
        {
            var allUserDataList = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
            for userData in allUserDataList
            {
                if userData["usernumber"] as! String == userNumber
                {
                    if (userData["truename"] as! String).isEmpty
                    {
                        result = userData["username"] as! String
                    }
                    else
                    {
                        result = userData["truename"] as! String
                    }
                }
            }
        }
        return result
    }
//    -(NSString *)getAvatarById:(NSString *)userId
//    {
//    NSString * result = userId;
//    NSString *path = [GetFilePath getUserDateListPath];
//    NSMutableArray * allUserDataList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    for (NSDictionary * userData in allUserDataList) {
//    if ([((NSString *)userData[@"userid"]) compare:userId] == NSOrderedSame) {
//    result = [NSString stringWithFormat:@"%@%@",serverURL,userData[@"avatar"]] ;
//    }
//    }
//    return  result;
//    }
    
    static func getAvatarById(userId:String)->String
    {
        var result = userId
        if GetFilePath.hasFile(GetFilePath.getUserDateListPath())
        {
            var path = GetFilePath.getUserDateListPath()
            var allUserDataList = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
            for userData in allUserDataList
            {
                if userData["userid"] as! String == userId
                {
                    result = ServerURL + (userData["avatar"] as! String)
                }
            }
        }
        return result
    }
    
    static func getAvatarByNumber(userNumber:String)->String
    {
        var result = userNumber
        if GetFilePath.hasFile(GetFilePath.getUserDateListPath())
        {
            var path = GetFilePath.getUserDateListPath()
            var allUserDataList = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
            for userData in allUserDataList
            {
                if userData["usernumber"] as! String == userNumber
                {
                    result = ServerURL + (userData["avatar"] as! String)
                }
            }
        }
        return result
    }
    /**
    获取和对方聊天的最后一条记录
    
    :param: userNumber 对方环信账号
    :returns: 返回最后一条纪录
    */
    static func getLocalLastMessage(userNumber:String)->EMMessage
    {
        var result = EMMessage()
        var allMessageList=NSMutableArray()
        if GetFilePath.hasFile(GetFilePath.getFilePath(userNumber))
        {
            allMessageList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getFilePath(userNumber)) as! NSMutableArray
        }
        if allMessageList.count>0
        {
            result=allMessageList[allMessageList.count-1] as! EMMessage
        }
        return result
    }
    /**
    保存黑名单数据
    
    :param: blacklist 黑名单列表
    */
    static func saveBlackList(blacklist:[[String:AnyObject]])
    {
        NSKeyedArchiver.archiveRootObject(blacklist, toFile: GetFilePath.getBlackListPath())
    }
    
    /**
    获取黑名单
    */
    static func getBlackList()->[[String:AnyObject]]
    {
        var result = [[String:AnyObject]]()
        if GetFilePath.hasFile(GetFilePath.getBlackListPath())
        {
            result = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getBlackListPath()) as! [[String:AnyObject]]
        }
        return result
    }
    /**
    检查该用户是否被屏蔽
    
    :param: data 用户数据
    
    :returns: 返回真假
    */
    static func InBalckList(userNumber:String)->Bool
    {
        var blackListData = [[String:AnyObject]]()
        if GetFilePath.hasFile(GetFilePath.getBlackListPath())
        {
            blackListData = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getBlackListPath()) as! [[String:AnyObject]]
        }
        for blackData in blackListData
        {
            if (blackData["friendusernumber"] != nil && (blackData["friendusernumber"] as! String).compare(userNumber, options: NSStringCompareOptions.allZeros, range: nil, locale: nil) == NSComparisonResult.OrderedSame)
            {
                return true
                
            }
        }
        return false
        
    }
}