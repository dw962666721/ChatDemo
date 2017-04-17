//
//  ForgetViewController0.swift
//  ChatDemo
//
//  Created by user on 15/10/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class ForgetViewController0: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userNameTextFiled: MyTextField!
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        userNameTextFiled.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func nextAction(sender: AnyObject) {
        var parameters = ["username":userNameTextFiled.text.TrimAndLine()]
        AFNetworkTool.postJSONWithUrl(GetMailByUserName, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                var forgetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ForgetPasswordViewController") as! ForgetPasswordViewController
                forgetVC.UserId = data["userid"] as! String
                forgetVC.Email = data["mail"] as! String
                self.navigationController?.pushViewController(forgetVC, animated: true)
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
        }) { (error) -> Void in
             messageBox.showAlert("访问服务器失败")
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
