//
//  ChooseViewStyleClearDown.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class ChooseViewStyleClearDown: ChooseView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    @IBInspectable var aaValue : String
        {
        get {return self.valueLabel.text!;}
        set{self.valueLabel.text=newValue;}
    }
    @IBInspectable var aaColor : UIColor
        {
        get {return self.valueLabel.textColor;}
        set{self.valueLabel.textColor=newValue;}
    }
    @IBInspectable var aaFont : UIFont
        {
        get {return self.valueLabel.font!;}
        set{self.valueLabel.font=newValue;}
    }
    var fontSize :CGFloat = 15
    @IBInspectable var aaFontSize : CGFloat
        {
        get {return fontSize}
        set
        {
            fontSize = newValue
            self.valueLabel.font = UIFont.systemFontOfSize(fontSize)
        }
    }
    override func layoutSubviews() {
        self.button.frame = self.bounds
        self.button.viewWithTag(9527)?.frame = CGRect(x: self.frame.size.width - 9 - 10, y: 10, width: 9, height: 7)
        self.valueLabel.frame = CGRect(x: 5, y: 0, width: self.frame.size.width - self.button.viewWithTag(9527)!.frame.size.width-10, height: self.frame.size.height)
    }
    func subViewInit(){
        
        var pImageView = UIImageView(frame: CGRect(x: self.frame.size.width - 9 - 10,  y: 10, width: 9, height: 7))
        pImageView.tag=9527;
        pImageView.userInteractionEnabled = false
        pImageView.image = UIImage(named: "向下箭头")
        
        
        var button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.tag=9999;
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        button.titleEdgeInsets = UIEdgeInsetsMake(6, frame.size.width / 2 , 5, 20);
        button.setTitle("",forState:UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal)
        button.titleLabel!.textAlignment=NSTextAlignment.Right
        button.titleLabel!.font = UIFont.systemFontOfSize(13)
        button.addSubview(pImageView)
        self.addSubview(button)
        
        self.button=button;
        var selectedTitleLabel:UILabel  = UILabel(frame: CGRectMake(5, 0, frame.size.width - 10, frame.size.height))
        selectedTitleLabel.font = UIFont.systemFontOfSize(13)
        selectedTitleLabel.textAlignment = NSTextAlignment.Center
        selectedTitleLabel.textColor = UIColor.blackColor()
        self.valueLabel = selectedTitleLabel;
        self.addSubview(selectedTitleLabel)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}

