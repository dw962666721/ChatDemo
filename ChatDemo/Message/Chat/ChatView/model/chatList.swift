//
//  chatList.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class chatList: NSObject,NSCoding{
   
    var userAvatarImgView:String = "" //用户头像
    var userNickName:String = ""//用户昵称
    var chatContent:String? = ""//聊天内容
    var chatHistoryTime:String = ""//聊天时间
    var userRank:Int = 0//用户等级
    var userId:Int = 0//用户Id
    var newMsg:Int? = 0 // 新消息
    var picture:String? = "" // 图片
    var record:String?=""

    init(dictionary:NSDictionary)
    {
        super.init()
        self.userAvatarImgView = dictionary["user"]!["avatarUrl"]! as! String
        self.userNickName = dictionary["user"]!["userName"]! as! String
        self.chatHistoryTime = dictionary.objectForKey("createTime") as! String
        self.userRank = dictionary["user"]!["rank"]! as! Int
        self.userId = dictionary["user"]!["userId"]! as! Int
        self.newMsg = dictionary.objectForKey("newMsg") as? Int
        self.chatContent = dictionary.objectForKey("message") as? String
        self.picture=dictionary.objectForKey("picture") as? String
        self.record=dictionary.objectForKey("record") as? String

    }
    // 序列化
    func encodeWithCoder(aCoder: NSCoder)
    {

        aCoder.encodeInteger(self.userId, forKey: "userId")
        aCoder.encodeInteger(self.newMsg!, forKey: "newMsg")
        aCoder.encodeInteger(self.userRank, forKey: "userRank")
        aCoder.encodeObject(self.userNickName, forKey: "userName")
        aCoder.encodeObject(self.chatHistoryTime, forKey: "createTime")
        aCoder.encodeObject(self.userAvatarImgView, forKey: "avatarUrl")
        aCoder.encodeObject(self.chatContent, forKey: "message")
        aCoder.encodeObject(self.record, forKey: "record")
        aCoder.encodeObject(self.picture, forKey: "picture")
    }
    // 反序列化
    required init(coder aDecoder: NSCoder)
    {
        super.init()
        self.userId = aDecoder.decodeIntegerForKey("userId")
        self.newMsg=aDecoder.decodeIntegerForKey("newMsg")
        self.userRank=aDecoder.decodeIntegerForKey("userRank")
        self.userNickName=aDecoder.decodeObjectForKey("userName") as! String
        self.chatHistoryTime=aDecoder.decodeObjectForKey("createTime") as! String
        self.userAvatarImgView=aDecoder.decodeObjectForKey("avatarUrl") as! String
        self.chatContent=aDecoder.decodeObjectForKey("message") as? String
        self.userAvatarImgView=aDecoder.decodeObjectForKey("avatarUrl") as! String
        self.record=aDecoder.decodeObjectForKey("record") as? String
        self.picture=aDecoder.decodeObjectForKey("picture") as? String

    }
}
