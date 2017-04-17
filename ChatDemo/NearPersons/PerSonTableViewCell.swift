//
//  PerSonTableViewCell.swift
//  ChatDemo
//
//  Created by user on 15/9/9.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class PerSonTableViewCell: UITableViewCell {

    @IBOutlet weak var avarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avarImageView.layer.masksToBounds = true
        avarImageView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(dataItem:[String:AnyObject])
    {
        if let userSex = dataItem["usersex"] as? String
        {
            if userSex == "1"
            {
                sexImageView.image = UIImage(named: "ManIco")
                ageLabel.backgroundColor = UIColor(rgbByFFFFFF: 0x99B9FF)
                sexImageView.backgroundColor = UIColor(rgbByFFFFFF: 0x99B9FF)
            }
            else
            {
                sexImageView.image = UIImage(named: "WomenIco")
                ageLabel.backgroundColor = UIColor(rgbByFFFFFF: 0xFF8CAB)
                sexImageView.backgroundColor = UIColor(rgbByFFFFFF: 0xFF8CAB)
            }
        }
        /// 用户年龄
        if let age = dataItem["userage"] as? String
        {
            ageLabel.text = age + " "
        }
        /// 用户签名
        if let userMarkl = dataItem["usermarkl"] as? String
        {
            signatureLabel.text = userMarkl
        }
        /// 用户头像
        if let userAvatar = dataItem["useravatar"] as? String
        {
            avarImageView.sd_setImageWithURL(NSURL(string: ServerURL + userAvatar), placeholderImage: UIImage(named: "logo"))
        }
        /// 用户状态
        if let userLoginTime = dataItem["userlogintime"] as? String
        {
            stateLabel.text = userLoginTime == "" ? "" : getTimeState(userLoginTime)
        }
        /// 用户姓名
        if let userid = dataItem["userid"] as? String
        {
            nameLabel.text = PropertyController.getNameById(userid)
            if nameLabel.text == userid
            {
                if let username = dataItem["username"] as? String
                {
                    nameLabel.text = username
                }
            }
        }        
    }
    func getTimeState(userLoginTime:String)->String
    {
        var result = userLoginTime
        var formmator = NSDateFormatter()
        formmator.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var date = formmator.dateFromString(userLoginTime)
//        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        unsigned int unitFlags = NSDayCalendarUnit;
//        NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:now  options:0];
//        int days = [comps day];
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var comps = calendar.components(NSCalendarUnit.SecondCalendarUnit, fromDate: date!, toDate: NSDate(), options: NSCalendarOptions.allZeros)
        var second = comps.second
        if second<60 // 小于一分钟
        {
            result = "刚刚"
        }
        else if second<60*60 // 小于一小时
        {
            result = toString(second/60) + "分钟前"
        }
        else if second<60*60*24 // 小于一天
        {
             result = toString(second/(60*60)) + "小时前"
        }
        else if second<60*60*24*30 // 小于一个月
        {
            result = toString(second/(60*60*24)) + "天前"
        }
        else if second<60*60*24*30*12 // 小于一年
        {
            result = toString(second/(60*60*24*30)) + "个月前"
        }
        else // 大于一年
        {
            result = toString(second/(60*60*24*30*12)) + "年前"
        }
        return result
    }
    @IBAction func agreeAction(sender: AnyObject) {
    }
}
