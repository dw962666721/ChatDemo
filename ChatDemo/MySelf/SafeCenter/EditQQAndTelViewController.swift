//
//  EditQQAndTelViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class EditQQAndTelViewController: UIViewController {

    var type = 0 // 0:修改QQ 1：修改手机
    var textFiled:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 0
        {
            self.title = "修改QQ号"
        }
        else
        {
            self.title = "修改手机号码"
        }
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf0f0f0)
        var label = UILabel(frame: CGRect(x: 20, y: 20, width: screenWidth, height: 15))
        label.font = UIFont.systemFontOfSize(12)
        label.text = "请输入QQ号码"
        if type == 1
        {
            label.text = "请输入手机号码"
        }
        label.textColor = UIColor.grayColor()
        self.view.addSubview(label)
//        
//        var viewContent = UIView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 45))
//        viewContent.backgroundColor = UIColor.whiteColor()
//        
//        var labelTitle = UILabel()
//        labelTitle.text = "请输入新的qq号码"
        
        textFiled = UITextField(frame: CGRect(x: 20, y: 40, width: screenWidth-40, height: 30))
        textFiled.keyboardType = UIKeyboardType.NumberPad
        textFiled.borderStyle = UITextBorderStyle.RoundedRect
        textFiled.placeholder = "请输入新的QQ号码"
        if type == 1
        {
            textFiled.placeholder = "请输入新的手机号码"
        }
        self.view.addSubview(textFiled)
        
        var rightBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        rightBtn.tintColor = UIColor(rgbByFFFFFF: 0x0079FD)
        self.navigationItem.setRightBarButtonItem(rightBtn, animated: true)
        // Do any additional setup after loading the view.
    }
    func verification()->Bool{
        var result = true
        if type==1 && !VerificatePhoneFormat.verificatePhoneFormat(textFiled.text.TrimAndLine())
        {
            messageBox.showAlert("手机格式不正确!")
            result = false
        }
        return result
    }
    func save()
    {
        if verification()
        {
        var paramers = ["userid":UserInfo.userID]
        if type == 0
        {
            paramers["qq"] = textFiled.text.TrimAndLine()
        }
        else
        {
            paramers["tel"] = textFiled.text.TrimAndLine()
        }
            bufferInfoView.show(self.view)
        AFNetworkTool.postJSONWithUrl((type == 0 ? UpdateQQURL : UpdateTelURL), parameters: paramers, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                messageBox.showAlert("修改成功")
                self.navigationController?.popViewControllerAnimated(true)
                if self.type == 0
                {
                    UserInfo.QQ = self.textFiled.text.TrimAndLine()
                }
                else
                {
                    UserInfo.Tel = self.textFiled.text.TrimAndLine()
                }
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            bufferInfoView.hiden()
        }) { (error) -> Void in
            messageBox.showAlert("修改未成功0")
            bufferInfoView.hiden()
        }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
