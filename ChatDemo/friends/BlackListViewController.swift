//
//  BlackListViewController.swift
//  ChatDemo
//
//  Created by user on 16/2/2.
//  Copyright (c) 2016年 user. All rights reserved.
//

import UIKit

class BlackListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView!
    var dataArray=[[String:AnyObject]]()
    func reloadData()
    {
        var params = ["userid":UserInfo.userID]
        bufferInfoView.show(self.view)
        AFNetworkTool.postJSONWithUrl(GetBlackListURL, parameters: params, success: { (jsData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                self.dataArray = data["friendlist"] as! [[String:AnyObject]]
                PropertyController.saveBlackList(self.dataArray)
                self.tableView.reloadData()
            }
            else
            {
                
            }
            bufferInfoView.hiden()
            }, fail: { (error) -> Void in
                messageBox.showAlert("连接服务器失败")
                bufferInfoView.hiden()
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "黑名单"
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
               tableView.registerNib(UINib(nibName: "NewFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        reloadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! NewFriendTableViewCell
        cell.setData(dataArray[indexPath.row])
        cell.isFriend()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            var params = ["usernumber":UserInfo.UserNumber,"blackusernumber":dataArray[indexPath.row]["friendusernumber"]!]
            var url = DelBlackListURL
            AFNetworkTool.postJSONWithUrl(url, parameters: params, success: { (jsData) -> Void in
                var data = NSJSONSerialization.JSONObjectWithData(jsData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
                var result = data["res"] as! String
                if result == "1"
                {
                    self.dataArray.removeAtIndex(indexPath.row)
                    PropertyController.saveBlackList(self.dataArray)
                    self.tableView.reloadData()
                }
                else
                {
                    messageBox.showAlert("连接服务器失败")
                }
                }, fail: { (error) -> Void in
                    messageBox.showAlert("连接服务器失败")
            })

        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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
