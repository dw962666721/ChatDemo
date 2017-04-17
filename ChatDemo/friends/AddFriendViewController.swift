//
//  AddFriendViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/17.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBOutlet weak var oprateView: UIView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var dataItem:[String:AnyObject]! //好友信息
    override func viewDidLoad() {
        super.viewDidLoad()
        NSBundle.mainBundle().loadNibNamed("AddFriendViewController", owner: self, options: nil)[0]
        self.title = "好友申请"
        refuseBtn.layer.masksToBounds = true
        refuseBtn.layer.cornerRadius = 5
        
        agreeBtn.layer.masksToBounds = true
        agreeBtn.layer.cornerRadius = 5
        
        setData()
        // Do any additional setup after loading the view.
    }
    func setData()
    {
        /// 用户签名
        if let userMarkl = dataItem["friendmark"] as? String
        {
            remarkLabel.text = userMarkl=="" ? "他什么也没说....." : userMarkl
        }
        else
        {
            remarkLabel.text = "他什么也没说....."
        }
        /// 用户头像
        if let userAvatar = dataItem["friendavatarL"] as? String
        {
            imageView.sd_setImageWithURL(NSURL(string: ServerURL + userAvatar), placeholderImage: UIImage(named: "logo"))
        }
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
        
        /// 好友处理状态
        if let statue = dataItem["statue"] as? String
        {
            oprateView.hidden = true
            resultView.hidden = true
            if statue == "0"
            {
                 oprateView.hidden = false
            }
            else if statue == "1"
            {
                resultView.hidden = false
                resultLabel.text = "该申请已被无情的拒绝"
            }
            else if statue == "2"
            {
                resultView.hidden = false
                resultLabel.text = "该申请已被对方同意"
            }
            else if statue == "3"
            {
                resultView.hidden = false
                resultLabel.text = "您已拒绝该申请"
            }
            else if statue == "4"
            {
                resultView.hidden = false
                resultLabel.text = "您已同意该好友申请"
            }
        }
    }
    
    @IBAction func refuseAction(sender: AnyObject) {
        var parameters = ["askid":dataItem["askid"]!,"userid":dataItem["friendid"]!,"friendid":UserInfo.userID]
        AFNetworkTool.postJSONWithUrl(RefusedFriendURL, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                messageBox.showAlert("拒绝成功")
                self.dataItem["statue"] = "3"
                self.saveDataItem(self.dataItem)
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            
        }) { (error) -> Void in
             messageBox.showAlert("访问服务器失败")
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
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            
            }) { (error) -> Void in
                messageBox.showAlert("添加失败0")
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
