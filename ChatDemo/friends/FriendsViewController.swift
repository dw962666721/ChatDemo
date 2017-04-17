//
//  FriendsViewController.swift
//  ChatDemo
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate{
    
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var dataArray:[[String:AnyObject]]=[] // 所有好友列表
//    var unDealFrendArray:[[String:AnyObject]]=[] // 所有好友请求列表
    var isLoading = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        if !isLoading
        {
            loadUnDealFriend()
        }
        toLoginAndRegistView()
    }
    func reloadData(page:Int=0)
    {
        var parameters = ["userid":UserInfo.userID]
        AFNetworkTool.postJSONWithUrl(GetMyFriendURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result=="1"
            {
                self.dataArray = json["friendlist"] as! [[String:AnyObject]]
            }
            else
            {
                messageBox.showAlert(json["msg"] as! String)
                self.dataArray = []
            }
            self.tableView.reloadData()
            }) { (error) -> Void in
              messageBox.showAlert("未获取到好盆友，请把网开开好吗？")
        }
    }
    func loadUnDealFriend()
    {
        isLoading = true
        var parameters = ["userid":UserInfo.userID]
        AFNetworkTool.postJSONWithUrl(GetfriendAskCountURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            var cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? FriendTableViewCell
            if result=="1"
            {
                var count = (json["count"] as! String).toInt()
                if (cell != nil)
                {
                    cell?.setCount(count!)
                }
            }
            else
            {
                messageBox.showAlert(json["msg"] as! String)
            }
            self.isLoading = false
            }) { (error) -> Void in
                messageBox.showAlert()
                self.isLoading = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserInfo.refresh()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "toLoginAndRegistView", name: "toLoginAndRegistView2", object: nil)
        
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.registerNib(UINib(nibName: "NewFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        var viewFoot = UIView()
        viewFoot.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = viewFoot
        
        var rightBtn = UIButton(frame: CGRectMake(0, 0, 45, 22))
        rightBtn.setTitle("黑名单", forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        rightBtn.addTarget(self, action: "balckListAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        // Do any additional setup after loading the view.
    }
    func toLoginAndRegistView()
    {
        if !UserInfo.isLogin
        {
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var guidanceVC = LoginAndRegistViewController()
                    guidanceVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(guidanceVC, animated: false)
                })
            })
        }
    }
    func balckListAction()
    {
        var blackListVC = BlackListViewController()
        blackListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(blackListVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    var selectedIndex = -1
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var alertAction = UIAlertView(title: "确认删除该好友？", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
        selectedIndex = indexPath.row
        alertAction.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            var paramters = ["userid":UserInfo.userID,"friendid":dataArray[selectedIndex]["friendid"] as! String]
            AFNetworkTool.postJSONWithUrl(DelFriendURL, parameters: paramters, success: { (jsonData) -> Void in
                var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
                var result = data["res"] as! String
                if result == "1"
                {
                    messageBox.showAlert("删除好友成功")
                    self.dataArray.removeAtIndex(self.selectedIndex)
                    self.tableView.reloadData()
                }
                else
                {
                    messageBox.showAlert(data["msg"] as! String)
                }
            }, fail: { (error) -> Void in
                
            })
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else
        {
            return dataArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCellWithIdentifier("cell") as! FriendTableViewCell
            switch indexPath.row
            {
            case 0:
                (cell as! FriendTableViewCell).setDate(0,date: ["friendname":"申请与通知"])
                break
            default:
                break
            }
        }
        else
        {
            cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! NewFriendTableViewCell
            (cell as! NewFriendTableViewCell).setData(dataArray[indexPath.row])
            (cell as! NewFriendTableViewCell).isFriend()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        else
        {
            return 20
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 创建一个会话窗口
        if indexPath.section==1
        {
            var vc = EditInformationViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.userId = dataArray[indexPath.row]["friendid"] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            var vc = NewFriendsViewController()
             vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
