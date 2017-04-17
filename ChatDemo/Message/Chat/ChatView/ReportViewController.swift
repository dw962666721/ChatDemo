//
//  ReportViewController.swift
//  ChatDemo
//
//  Created by user on 16/1/15.
//  Copyright (c) 2016年 user. All rights reserved.
//

import UIKit
class reportCell:UITableViewCell
{
    var titleLabel:UILabel!
    var imageViewItem:UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    func addViews()
    {
        titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.bounds.width, height: self.bounds.height))
        titleLabel.font = UIFont.systemFontOfSize(12)
        self.addSubview(titleLabel)
        
        imageViewItem = UIImageView(frame: CGRect(x: self.bounds.width-45, y: 15, width: 15, height: 15))
        self.addSubview(imageViewItem)
    }
    func setTitle(title:String)
    {
        self.titleLabel.text = title
    }
    func setState(selected:Bool)
    {
        if selected
        {
            imageViewItem.image = UIImage(named: "对勾")
        }
        else
        {
            imageViewItem.image = nil
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
class ReportViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    var tableView:UITableView!
    
    var textFiled:UITextField!
    
//    var emailTextFiled:UITextField! // 邮箱账号
    var successView:UIView!
    
    var reportType=["垃圾消息骚扰","传播色情暴力","欺诈骗钱"]
    var dateItem:[String:AnyObject]=["userNumber":"","title":"","toEmail":"798833403@qq.com","fromEmail":"","content":""]
    var blackListSwitch:UISwitch! // 黑名单Switch
    var eulaBtn : UIButton! // 协议按钮
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xf0f0f0)
        self.title = "举报"
        addViews()
        // Do any additional setup after loading the view.
    }
    func addViews()
    {
//        var toLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 70, height: 20))
//        toLabel.text = "您的邮箱:"
//        self.view.addSubview(toLabel)
//        
//        emailTextFiled = UITextField(frame: CGRect(x: 75, y: 5, width: screenWidth-80, height: 20))
//        emailTextFiled.delegate = self
//        emailTextFiled.text = UserInfo.Mail
//        self.view.addSubview(emailTextFiled)
        
        tableView = UITableView(frame: CGRect(x: 5, y: 15, width: screenWidth-10, height: 45*3))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.registerClass(reportCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        tableView.reloadData()
        
//        var contentLabel = UILabel(frame: CGRect(x: 5, y: CGRectGetMaxY(tableView.frame) + 20, width: 100, height: 20))
//        contentLabel.text = "举报内容"
//        self.view.addSubview(contentLabel)
        
        textFiled = UITextField(frame: CGRect(x: -1, y: CGRectGetMaxY(tableView.frame) + 5, width: screenWidth+2, height: 45))
        textFiled.font = UIFont.systemFontOfSize(13)
        textFiled.delegate = self
        textFiled.placeholder = "[选填] 请填写举报内容"
        textFiled.placeholderRectForBounds(CGRect(origin: CGPoint.zeroPoint, size: textFiled.frame.size))
        textFiled.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(textFiled)
        
        var tipLabel = UILabel(frame: CGRect(x: 15, y: CGRectGetMaxY(textFiled.frame)+10, width: screenWidth-30, height: 20))
        tipLabel.font = UIFont.systemFontOfSize(13)
        tipLabel.text = "该账号的最近10条消息，也将作为证据一并提交。"
        self.view.addSubview(tipLabel)
        
        var blackListLable = UILabel(frame: CGRect(x: 15, y: CGRectGetMaxY(tipLabel.frame)+10, width: 100, height: 30))
        blackListLable.font = UIFont.systemFontOfSize(13)
        blackListLable.text = "屏蔽此人"
        self.view.addSubview(blackListLable)
        
        blackListSwitch = UISwitch(frame: CGRect(x: screenWidth-15-50, y: CGRectGetMinY(blackListLable.frame), width: 50, height: 30))
        blackListSwitch.addTarget(self, action: "balckListAction", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(blackListSwitch)
        
        if PropertyController.InBalckList(self.dateItem["userNumber"] as! String)
        {
            self.blackListSwitch.on = true
        }
        else
        {
            self.blackListSwitch.on = false
        }
        
        eulaBtn =  UIButton(frame: CGRect(x: (screenWidth - 80 )/2, y: self.view.frame.height - 45-64, width: 80, height: 45))
        eulaBtn.setTitle("举报须知", forState: UIControlState.Normal)
        eulaBtn.setTitleColor(UIColor(rgbByFFFFFF: 0x21bce6), forState: UIControlState.Normal)
        eulaBtn.addTarget(self, action: "toEulaView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(eulaBtn)
        
        var buttonRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 45))
        buttonRight.setTitle("提交", forState: UIControlState.Normal)
        buttonRight.addTarget(self, action: "commitAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonRight)
        
        
        
        successView = UIView(frame: self.view.frame)
        successView.hidden = true
        successView.backgroundColor =  UIColor(rgbByFFFFFF: 0xf0f0f0)
        self.view.addSubview(successView)
        
        var stateLabel = UILabel(frame: CGRect(x: 0, y: 50, width: screenWidth, height: 20))
        stateLabel.text = "举报成功"
        stateLabel.textAlignment = NSTextAlignment.Center
        successView.addSubview(stateLabel)
        
        var stateContentLabel = UILabel(frame: CGRect(x: 5, y: CGRectGetMaxY(stateLabel.frame), width: screenWidth-10, height: 100))
        stateContentLabel.text = "感谢您的支持，我们会尽快处理并将结果发送至您的邮箱(" + UserInfo.Email + ")"
        stateContentLabel.numberOfLines = 0
        successView.addSubview(stateContentLabel)
        
        var returnBtn = UIButton(frame: CGRect(x: 15, y: CGRectGetMaxY(stateContentLabel.frame)+15, width: screenWidth-30, height: 45))
        returnBtn.setTitle("返回", forState: UIControlState.Normal)
        returnBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        returnBtn.backgroundColor = UIColor(rgbByFFFFFF: 0x27B0E1)
        returnBtn.addTarget(self, action: "returnAction", forControlEvents: UIControlEvents.TouchUpInside)
        returnBtn.layer.cornerRadius = 5
        successView.addSubview(returnBtn)
        
    }
    func balckListAction()
    {
        var bo = blackListSwitch.on // on 选中 off 未选中
        var params = ["usernumber":UserInfo.UserNumber,"blackusernumber":dateItem["userNumber"]!]
        var url = DelBlackListURL
        if bo
        {
            url = AddBlackListURL
        }
        AFNetworkTool.postJSONWithUrl(url, parameters: params, success: { (jsData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                self.refreshBlackList()
            }
            else
            {
                messageBox.showAlert("连接服务器失败")
                self.blackListSwitch.on = !self.blackListSwitch.on
            }
            }, fail: { (error) -> Void in
                messageBox.showAlert("连接服务器失败")
        })

        
    }
    /**
    更新黑名单列表
    */
    func refreshBlackList()
    {
        var params = ["userid":UserInfo.userID]
        AFNetworkTool.postJSONWithUrl(GetBlackListURL, parameters: params, success: { (jsData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                var dataArray = data["friendlist"] as! [[String:AnyObject]]
                PropertyController.saveBlackList(dataArray)
            }
            }, fail: { (error) -> Void in
                messageBox.showAlert("连接服务器失败")
        })

    }
    /**
    进入举报须知
    */
    func toEulaView()
    {
        var eulaVC = UIViewController()
        eulaVC.title = "举报须知"
        var webView = UIWebView(frame: eulaVC.view.frame)
        var resourcePath = NSBundle.mainBundle().resourcePath;
        var filePath = resourcePath?.stringByAppendingPathComponent("eula.html")
        var htmlString = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
        webView.loadHTMLString((htmlString as! String), baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))
        eulaVC.view.addSubview(webView)
        self.navigationController?.pushViewController(eulaVC, animated: true)
    }
    
    func returnAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /**
    提交
    */
    func commitAction()
    {
        self.view.endEditing(true)
        var paramers = ["title":dateItem["title"]!,"body":(dateItem["content"] as! String)  + "来自于:" + UserInfo.Email + "\n" + textFiled.text,"mail":"798833403@qq.com"]
        bufferInfoView.show(self.view)
        AFNetworkTool.postJSONWithUrl(ReportURL, parameters: paramers, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                self.successView.hidden = false
                self.title = "举报成功"
                self.navigationItem.rightBarButtonItem = nil
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            bufferInfoView.hiden()
            }, fail: { (error) -> Void in
                bufferInfoView.hiden()
        })
        
    }
    func setData(date:[String:AnyObject])
    {
        self.dateItem = date
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! reportCell
        cell.setTitle(reportType[indexPath.row])
        if indexPath.row == 0
        {
            cell.setState(true)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportType.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) != nil)
        {
            var cell0 = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! reportCell
            cell0.setState(false)
        }
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! reportCell
        cell.setState(true)
       
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! reportCell
        cell.setState(false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
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
