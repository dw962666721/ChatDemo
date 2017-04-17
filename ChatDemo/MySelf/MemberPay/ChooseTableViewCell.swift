//
//  ChooseTableViewCell.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class ChooseTableViewCell: UITableViewCell {

    @IBOutlet weak var icoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setData(row:Int,memberItem:[String:AnyObject])
    {
        if row<=2
        {
            icoImageView.image = UIImage(named: "ic_setting_vip" + toString(row+1))
        }
        if let memberlevelname = memberItem["memberlevelname"] as? String
        {
            titleLabel.text = memberlevelname
        }
    }
}
