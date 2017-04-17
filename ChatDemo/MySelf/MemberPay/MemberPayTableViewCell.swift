//
//  MemberPayTableViewCell.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
protocol MemberPayDelegate:NSObjectProtocol
{
    func memberPay(year:Int,price:Int,memberItem:[String:AnyObject])
}

class MemberPayTableViewCell: UITableViewCell{

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceBtn: UIButton!
    var delegate : MemberPayDelegate!
    var memberItem:[String:AnyObject]!
    var totalPrice = 0
    var year = 0
    var price = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        timeImageView.layer.masksToBounds = true
        timeImageView.layer.cornerRadius = 10
        
        priceBtn.layer.masksToBounds = true
        priceBtn.layer.cornerRadius = 5
        
        var tap = UITapGestureRecognizer(target: self, action: "payAction")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        mainView.addGestureRecognizer(tap)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(index:Int,year:Int,memberitem:[String:AnyObject])
    {
        self.memberItem = memberitem
        timeImageView.image = UIImage(named: "ic_setting_vip"+toString(index+1))
        var price = (memberitem["memberlevelprice"] as! String).toInt()
        self.totalPrice = (year-1)*100+price!
        if year != 1
        {
            self.totalPrice-=10
        }
        self.year = year
        self.price = price!
        priceBtn.setTitle("  ￥"+toString(totalPrice)+"  ", forState: UIControlState.Normal)
        timeLabel.text = toString(year) + "年"
    }
    
    @IBAction func priceBtnAction(sender: AnyObject) {        
        payAction()
    }
    
    func payAction()
    {
        delegate.memberPay(self.year, price: self.price, memberItem: self.memberItem)
    }
}
