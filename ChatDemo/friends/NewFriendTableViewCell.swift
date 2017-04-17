//
//  PerSonTableViewCell.swift
//  ChatDemo
//
//  Created by user on 15/9/9.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class NewFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var moreImageView: UIImageView!
    var dataItem:[String:AnyObject]!
    override func awakeFromNib() {
        super.awakeFromNib()
        avarImageView.clipsToBounds = true
        avarImageView.layer.cornerRadius = 25
        
        agreeBtn.layer.masksToBounds = true
        agreeBtn.layer.cornerRadius = 5
        agreeBtn.layer.borderColor = UIColor.grayColor().CGColor
        agreeBtn.layer.borderWidth = 0.5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setData(dataItem:[String:AnyObject])
    {
        self.dataItem = dataItem
        if let userSex = dataItem["friendsex"] as? String
        {
            if userSex == "1"
            {
                sexImageView.image = UIImage(named: "ManIco")
                sexImageView.backgroundColor = UIColor(rgbByFFFFFF: 0x99B9FF)
                ageLabel.backgroundColor = UIColor(rgbByFFFFFF: 0x99B9FF)
            }
            else
            {
                sexImageView.image = UIImage(named: "WomenIco")
                sexImageView.backgroundColor = UIColor(rgbByFFFFFF: 0xFF8CAB)
                ageLabel.backgroundColor = UIColor(rgbByFFFFFF: 0xFF8CAB)
            }
        }
        /// 用户年龄
        if let age = dataItem["friendage"] as? String
        {
            ageLabel.text = age + " "
        }
        /// 用户签名
        if let userMarkl = dataItem["friendmark"] as? String
        {
            signatureLabel.text = userMarkl=="" ? "他什么也没说....." : userMarkl
        }
        else
        {
            signatureLabel.text = "他什么也没说....."
        }
        /// 用户头像
        if let userAvatar = dataItem["friendavatarL"] as? String
        {
            avarImageView.sd_setImageWithURL(NSURL(string: ServerURL + userAvatar), placeholderImage: UIImage(named: "logo"))
        }
//        /// 用户姓名
//        if let userName = dataItem["friendname"] as? String
//        {
//            nameLabel.text = userName
//        }
        /// 用户姓名
        if let userid = dataItem["friendid"] as? String
        {
            nameLabel.text = PropertyController.getNameById(userid)
            if nameLabel.text == userid
            {
                if let username = dataItem["friendname"] as? String
                {
                    nameLabel.text = username
                }
            }
        }
        /// 用户状态
        if let userLoginTime = dataItem["userlogintime"] as? String
        {
            stateLabel.text = userLoginTime
        }
        
        /// 好友处理状态
        if let statue = dataItem["statue"] as? String
        {
            if statue == "0"
            {
                setBtnNormal()
            }
            else if statue == "1"
            {
                setBtnText("被拒绝")
            }
            else if statue == "2"
            {
                setBtnText("已同意")
            }
            else if statue == "3"
            {
                setBtnText("已拒绝")
            }
            else if statue == "4"
            {
                setBtnText("已同意")
            }
        }

       
        
    }
    func isFriend()
    {
        sexImageView.hidden = false
        ageLabel.hidden = false
        agreeBtn.hidden = true
        moreImageView.hidden = true
    }
    
    @IBAction func agreeAction(sender: AnyObject) {
        var parameters = ["askid":dataItem["askid"]!,"userid":dataItem["friendid"]!,"friendid":UserInfo.userID]
        AFNetworkTool.postJSONWithUrl(AddFrienURL, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                messageBox.showAlert("添加好友成功")
                self.dataItem["statue"] = "4"
                self.saveDataItem(self.dataItem)
                self.setBtnText("已同意")
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            
        }) { (error) -> Void in
             messageBox.showAlert("访问数据库失败")
        }
    }
    func saveDataItem(dataItem:[String:AnyObject]!)
    {
        var askList:[[String:AnyObject]]!
        if GetFilePath.hasFile(GetFilePath.getFriendAskListPath())
        {
            askList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getFriendAskListPath()) as! [[String:AnyObject]]
        }
        else
        {
            askList = []
        }
        askList.append(dataItem)
        NSKeyedArchiver.archiveRootObject(askList, toFile: GetFilePath.getFriendAskListPath())
    }
    func setBtnNormal()
    {
        agreeBtn.layer.borderWidth = 0.5
        agreeBtn.userInteractionEnabled = true
        agreeBtn.setTitle("同意", forState: UIControlState.Normal)
        agreeBtn.setTitleColor(UIColor(rgbByFFFFFF: 0x33CCFF), forState: UIControlState.Normal)
    }
    func setBtnText(text:String)
    {
        agreeBtn.layer.borderWidth = 0
        agreeBtn.userInteractionEnabled = false
        agreeBtn.setTitle(text, forState: UIControlState.Normal)
        agreeBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    }
}
