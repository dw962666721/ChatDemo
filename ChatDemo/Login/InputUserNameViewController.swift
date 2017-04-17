//
//  InputUserNameViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/8.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class InputUserNameViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    var registVC:RegisterViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextFiled.delegate = self
//        [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventValueChanged];
//        userNameTextFiled.addTarget(self, action: "textChange:", forControlEvents: UIControlEvents.ValueChanged)
        nextBtn.backgroundColor = UIColor.lightGrayColor()
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        userNameTextFiled.limitTextLength(15)
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        var sb = UIStoryboard(name: "Main", bundle: nil)
        registVC = sb.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        registVC.hidesBottomBarWhenPushed = true
    }
    func verification()->Bool
    {
        var result = true
        if ((userNameTextFiled.text == nil) || (userNameTextFiled.text.isEmpty))
        {
            messageBox.showAlert("用户名不能为空")
            result = false
        }
//        if !VerificatePhoneFormat.verificateUserName(userNameTextFiled.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
//        {
//            messageBox.showAlert("不符合用户名规则")
//            result = false
//        }
        return result
    }
    /**
    下一步 
    */
    @IBAction func nextAction(sender: AnyObject) {
        if (verification())
        {
            self.view.endEditing(true)
            bufferInfoView.show(self.view)
            var parameters = ["username":userNameTextFiled.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())]
            AFNetworkTool.postJSONWithUrl(PdUsernameURL, parameters: parameters, success: { (jsonData) -> Void in
                var dataArray = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:String]
                var result = dataArray["res"]
                if result == "1"
                {
                    self.registVC.userName = self.userNameTextFiled.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    self.navigationController?.pushViewController(self.registVC, animated: true)
                }
                else
                {
                    messageBox.showAlert(dataArray["msg"])
                }
                bufferInfoView.hiden()
            }, fail: { (error) -> Void in
                bufferInfoView.hiden()
                messageBox.showAlert("访问不到服务器")
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textChange(notifice:NSNotification)
    {
        if (notifice.object as! UITextField) != userNameTextFiled
        {
            return
        }
        if (userNameTextFiled.text == nil || userNameTextFiled.text.isEmpty)
        {
            nextBtn.backgroundColor = UIColor.lightGrayColor()
        }
        else
        {
            nextBtn.backgroundColor = UIColor(rgbByFFFFFF: 0x27B0E1)
        }

    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
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
