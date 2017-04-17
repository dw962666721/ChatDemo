//
//  DatePicker.swift
//  ChooseViewGroup
//
//  Created by user on 15/6/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class DateChooseView: ChooseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func subViewInit(){
        
        var button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.tag=9999;
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        button.titleEdgeInsets = UIEdgeInsetsMake(6, frame.size.width / 2 , 5, 20);
        button.setTitle("",forState:UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal)
        button.titleLabel!.textAlignment=NSTextAlignment.Right
        button.titleLabel!.font = UIFont.systemFontOfSize(13)
        self.addSubview(button)
        self.button=button;
        var selectedTitleLabel:UILabel  = UILabel(frame: CGRectMake(5, 0, frame.size.width - 10, frame.size.height))
        selectedTitleLabel.font = UIFont.systemFontOfSize(13)
        self.valueLabel = selectedTitleLabel;
        self.addSubview(selectedTitleLabel)
        
    }
    
    
    
    var maxdate:NSDate?
    var mindate:NSDate?
    @IBAction func pickerShow(sender: AnyObject) {
        self.datasource?.chooseViewPickerWillShow?(self)
        if (self.pickerView == nil)
        {
            self.datasource?.chooseView?(self, willClickButton: sender as! UIButton)
            var pickerView = UIDatePicker(frame: CGRectMake(0, 44, UIScreen.mainScreen().bounds.size.width, 60))
            if maxdate != nil
            {
                pickerView.maximumDate = maxdate
            }
            if mindate != nil
            {
                pickerView.minimumDate = mindate
            }
            pickerView.datePickerMode = UIDatePickerMode.Date
            self.pickerView=pickerView
        }
        self.setPicker()
    }
    
    override func sureButtonClicked()
    {
        var datePicker = self.pickerView as! UIDatePicker
        var formatter=NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var value = formatter.stringFromDate(datePicker.date)
        self.value = value
        self.cancelButtonClicked()
        self.datasource?.chooseViewSureButtonClicked?(self)
    }
    
    func addLableClick()
    {
        self.valueLabel.userInteractionEnabled = true
    }
    
}
