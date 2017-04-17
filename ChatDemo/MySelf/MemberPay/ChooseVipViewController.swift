//
//  ChooseVipViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class ChooseVipViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var tabelView: UITableView!
    var dataArray:[[String:AnyObject]]=[]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTime()
        if (tabelView.indexPathForSelectedRow() != nil)
        {            
            tabelView.deselectRowAtIndexPath(tabelView.indexPathForSelectedRow()!, animated: true)
        }
    }
    func reloadData()
    {
        bufferInfoView.show(self.view)
        AFNetworkTool.postJSONWithUrl(GetMemberLevelURL, parameters: [], success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
//            var canPay = data["iszfb"] as! String
//            if canPay == "1"
//            {
//                
//            }
//            else
//            {
//                var messageStr = data["msg"] as! String
//                if messageStr == "1" || messageStr == ""
//                 {
//                    messageStr = "暂只支持安卓会员充值"
//                }
//                messageBox.showAlert(messageStr)
//                self.navigationController?.popViewControllerAnimated(true)
//            }
            
            var result = data["res"] as! String
            if result == "1"
            {
                self.dataArray = data["memberlist"] as! [[String:AnyObject]]
                self.tabelView.reloadData()
            }
            else
            {
                messageBox.showAlert( data["msg"] as! String)
            }
            bufferInfoView.hiden()
        }) { (error) -> Void in
            messageBox.showAlert("链接服务器失败")
            self.navigationController?.popViewControllerAnimated(true)
            bufferInfoView.hiden()
        }
    }
    
    func loadTime()
    {
        var date = UserInfo.MemberendDate
        if date.isEmpty
        {
            timeLabel.text = ""
            return
        }
        // 到期时间 2015年9月21日
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var datetime = formatter.dateFromString(date)!
        var dateStr = "到期时间 " + toString(datetime.year) + "年" + toString(datetime.month) + "月" + toString(datetime.day) + "日"
        timeLabel.text = dateStr
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSBundle.mainBundle().loadNibNamed("ChooseVipViewController", owner: self, options: nil)[0]
        self.title = "选择会员级别"
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.registerNib(UINib(nibName: "ChooseTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tabelView.tableHeaderView = topView
        var viewFoot = UIView()
        viewFoot.backgroundColor = UIColor.clearColor()
        tabelView.tableFooterView = viewFoot
        reloadData()
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tabelView.dequeueReusableCellWithIdentifier("cell") as! ChooseTableViewCell
        cell.setData(indexPath.row, memberItem: dataArray[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = MemberPayViewController()
        vc.index = indexPath.row
        vc.memberItem = dataArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
