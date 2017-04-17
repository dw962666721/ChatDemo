//
//  NewFriendsViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class NewFriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var unDealFrendArray:[[String:AnyObject]]=[] // 所有好友请求列表
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUnDealFriend()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveFriendList()
    }
    func loadUnDealFriend()
    {
        var parameters = ["userid":UserInfo.userID]
        AFNetworkTool.postJSONWithUrl(GetFriendAskURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result=="1"
            {
                self.unDealFrendArray = json["friendlist"] as! [[String:AnyObject]]
                self.saveCache(self.unDealFrendArray)
                self.unDealFrendArray = self.unDealFrendArray + self.getHistoryFriendAsk()
                
                self.tableView.reloadData()
            }
            else
            {
                messageBox.showAlert(json["msg"] as! String)
            }
            }) { (error) -> Void in
                messageBox.showAlert(error.description)
        }
    }
    /**
    缓存数据
    
    :param: unDealFrendArray 所有获取的好友请求信息
    */
    func saveCache(unDealFrendArray:[[String : AnyObject]])
    {
        for dataItem in unDealFrendArray
        {
            if dataItem["statue"] as! String == "1" ||  dataItem["statue"] as! String == "2"
            {
//                saveDataItem(dataItem)
            }
        }
    }
    func getHistoryFriendAsk()->[[String:AnyObject]]
    {
        var friendHistoryList : [[String:AnyObject]]
        if GetFilePath.hasFile(GetFilePath.getFriendAskListPath())
        {
            friendHistoryList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getFriendAskListPath()) as! [[String:AnyObject]]
            
        }
        else
        {
            
            friendHistoryList = [[String:AnyObject]]()
        }
        return friendHistoryList
    }
    func saveFriendList()
    {
        var friendHistoryList : [[String : AnyObject]]
        if GetFilePath.hasFile(GetFilePath.getFriendAskListPath())
        {
            friendHistoryList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getFriendAskListPath()) as! [[String : AnyObject]]
            
        }
        else
        {
            friendHistoryList = [[String : AnyObject]]()
        }
        
        for unDealMessage in unDealFrendArray
        {
            var hasSame = false
            for var i=0;i<friendHistoryList.count;i++
            {
                var item = friendHistoryList[i]
                if item["askid"] as! String == unDealMessage["askid"] as! String
                {
//                    friendHistoryList[i] = unDealMessage
                    hasSame = true
                }
            }
            if !hasSame && (unDealMessage["statue"] as! String == "1" || unDealMessage["statue"] as! String == "2")
            {
                friendHistoryList.append(unDealMessage)
            }
        }
        NSKeyedArchiver.archiveRootObject(friendHistoryList, toFile: GetFilePath.getFriendAskListPath())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新朋友"
        NSBundle.mainBundle().loadNibNamed("NewFriendsViewController", owner: self, options: nil)[0]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "NewFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NewFriendTableViewCell
        cell.setData(unDealFrendArray[indexPath.row])
//        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = AddFriendViewController()
        vc.dataItem = self.unDealFrendArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unDealFrendArray.count
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        delAsk(unDealFrendArray[indexPath.row]["askid"] as! String)
        unDealFrendArray.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
        
    }
    func delAsk(askId:String)
    {
        var askList : [[String:AnyObject]]!
        if GetFilePath.hasFile(GetFilePath.getFriendAskListPath())
        {
            askList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getFriendAskListPath()) as! [[String:AnyObject]]
        }
        else
        {
            askList = []
        }
        for var i = 0 ;i<askList.count;i++
        {
            var askItem = askList[i]
            if askItem["askid"] as! String == askId
            {
                askList.removeAtIndex(i)
                break
            }
        }
        NSKeyedArchiver.archiveRootObject(askList, toFile: GetFilePath.getFriendAskListPath())
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
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
