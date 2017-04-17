//
//  FriendTableViewCell.swift
//  ChatDemo
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icoImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var unReadLabel: UILabel!
    
    var data:[String:AnyObject]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDate(section:Int,date: [String : AnyObject])
    {
        self.data = date
        if (data != nil)
        {
            if ( data["friendavatarL"] != nil)
            {
                icoImageView.sd_setImageWithURL(NSURL(string: ServerURL + (data["friendavatarL"] as! String)),placeholderImage: UIImage(named: "logo"))
            }
            if (data["friendname"] != nil)
            {
                nameLabel.text = data["friendname"] as? String
            }
            if (data["friendsex"] != nil)
            {
                sexImageView.image = UIImage(named: (data["friendsex"] as! String)=="1" ? "ManIco": "WomenIco")
            }
            if (data["friendage"] != nil)
            {
                ageLabel.text = (data["friendage"] as! String) + "岁"
            }
            if section == 0
            {
                ageLabel.hidden = true
                sexImageView.hidden = true
                topConstraint.constant = 15
                
                unReadLabel.layer.cornerRadius = 10
                unReadLabel.clipsToBounds=true
                icoImageView.image = UIImage(named: "ic_discover_group")
            }
        }
    }
    func setCount(count:Int)
    {
        if count == 0
        {
            unReadLabel.hidden = true
        }
        else
        {
            unReadLabel.hidden = false
            unReadLabel.text = toString(count)
            if count < 9
            {
                unReadLabel.font = UIFont.systemFontOfSize(13)
            }
            else if count<=99
            {
                unReadLabel.font = UIFont.systemFontOfSize(12)
            }
            else
            {
                unReadLabel.font = UIFont.systemFontOfSize(10)
            }

        }
    }
}
