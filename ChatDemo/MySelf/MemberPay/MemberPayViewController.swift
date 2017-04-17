//
//  MemberPayViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
class MemberPayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MemberPayDelegate ,ProductInfoDelegate,UIAlertViewDelegate,HelloWorldLayerDelegate{
    @IBOutlet weak var titleBtn: UIButton!
    var memberItem:[String:AnyObject]!
    @IBOutlet weak var tableView: UITableView!
    var index = 1 // 会员级别
    var yearArray=[1]
    var productInfo : ProductInfo!
    var selectedYear:Int!
    func CheckPay()
    {
        bufferInfoView.show(self.view)
        AFNetworkTool.postJSONWithUrl(PdzfbURL, parameters: [], success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            bufferInfoView.hiden()
            if result == "1"
            {
//                self.dataArray = data["memberlist"] as! [[String:AnyObject]]
//                self.tabelView.reloadData()
            }
            else
            {
                messageBox.showAlert( data["msg"] as! String)
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            }) { (error) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                messageBox.showAlert("链接服务器失败")
                bufferInfoView.hiden()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSBundle.mainBundle().loadNibNamed("MemberPayViewController", owner: self, options: nil)[0]
        self.title = "会员支付"
        titleBtn.setTitle((UserInfo.IsVip ? "续费" : "" ) + (memberItem?["memberlevelname"] as? String)!, forState: UIControlState.Normal)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "MemberPayTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        var viewFoot = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = viewFoot
        
        tableView.reloadData()
    }
    func setData(data:[String:AnyObject])
    {
        self.memberItem = data
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yearArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MemberPayTableViewCell
        if (memberItem != nil)
        {
            cell.setData(index,year: yearArray[indexPath.row], memberitem: memberItem)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.delegate = self
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getProduct(productType:Int,orderId:String)
    {
        HelloWorldLayer.buy(productType,orderId: orderId)
        HelloWorldLayer.indence.indence.delegate = self
    }
    /**
    支付回调
    
    :param: product 产品名称
    :param: code    支付结果 0:完成 1:失败 2:已经购买
    */
    func HelloWorldLayerFinish(OrderId: String, code: Int) {
        if code == 0
        {
            var date = UserInfo.MemberendDate
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            var changeDate : String!
            if date.isEmpty
            {
                var nowDate = NSDate()
                var dateComponents = NSDateComponents()
                dateComponents.year = self.selectedYear
                var calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
                var changeDateStr = calender?.dateByAddingComponents(dateComponents, toDate: nowDate, options: NSCalendarOptions.allZeros)
                UserInfo.MemberendDate = formatter.stringFromDate(changeDateStr!)
                messageBox.showAlert("充值" + toString(self.selectedYear) + "年会员 成功！")
                self.navigationController?.popViewControllerAnimated(true)
                UserInfo.IsVip = true
                return
            }
            // 到期时间 2015年9月21日
            var datetime = formatter.dateFromString(date)!
            var dateComponents = NSDateComponents()
            dateComponents.year = self.selectedYear
            var calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
            var changeDateStr = calender?.dateByAddingComponents(dateComponents, toDate: datetime, options: NSCalendarOptions.allZeros)
            
            UserInfo.MemberendDate = formatter.stringFromDate(changeDateStr!)
            messageBox.showAlert("续费" + toString(self.selectedYear) + "年会员 成功！")
            UserInfo.IsVip = true
            self.navigationController?.popViewControllerAnimated(true)
        }
        else if code == 1
        {
//            messageBox.showAlert("支付失败")
        }
        else
        {
            messageBox.showAlert("已经购买")
        }
    }

}
extension MemberPayViewController:MemberPayDelegate,ProductInfoDelegate,UIAlertViewDelegate
{
    func memberPay(year: Int, price: Int, memberItem: [String : AnyObject]) {
        self.selectedYear = year
        var totalPrice = (year-1)*100+price
        if year != 1
        {
            totalPrice-=10
        }
        var parameters = ["userid":UserInfo.userID,"memberlevelid":memberItem["memberlevelID"]!,"time":year,"price":totalPrice]
        bufferInfoView.show(self.view)
//        BufferView.showGif()
        AFNetworkTool.postJSONWithUrl(BuyMemberOrderURL, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
//                self.productInfo = ProductInfo()
//                ProductInfo.shareInstance().delegate = self
//                self.productInfo.delegate = self
//                self.productInfo.productName = "欲约会员支付"
//                self.productInfo.productDescription = "欲约会员支付"
//                self.productInfo.amount = toString(totalPrice); //商品价格
////                self.productInfo.amount = "0.01"; //商品价格
//                self.productInfo.createTradeno(data["msg"] as! String)
//                self.productInfo.aliPay()
                if SKPaymentQueue.canMakePayments()
                {
                    self.getProduct(year,orderId: data["msg"] as! String)
                }
                else
                {
                    messageBox.showAlert("止应用内付费购买.")
                }
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            bufferInfoView.hiden()
        }) { (erroe) -> Void in
             messageBox.showAlert("访问服务器失败")
            bufferInfoView.hiden()
        }
        
       
    }
    /**
    支付宝 支付完成回调
    
    :param: selfInfo  商品信息
    :param: resultDic 结果信息
    */
    func productPay(selfInfo: ProductInfo, resultDic: [NSObject : AnyObject]!) {
        if (resultDic["resultStatus"] as! String) == "9000"
        {
            var date = UserInfo.MemberendDate
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            var changeDate : String!
            if date.isEmpty
            {
                var nowDate = NSDate()
                var dateComponents = NSDateComponents()
                dateComponents.year = self.selectedYear
                var calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
                var changeDateStr = calender?.dateByAddingComponents(dateComponents, toDate: nowDate, options: NSCalendarOptions.allZeros)
                 UserInfo.MemberendDate = formatter.stringFromDate(changeDateStr!)
                messageBox.showAlert("充值" + toString(self.selectedYear) + "年会员 成功！")
                self.navigationController?.popViewControllerAnimated(true)
                UserInfo.IsVip = true
                return
            }
            // 到期时间 2015年9月21日
            var datetime = formatter.dateFromString(date)!
            var dateComponents = NSDateComponents()
            dateComponents.year = self.selectedYear
            var calender = NSCalendar(calendarIdentifier: NSGregorianCalendar)
            var changeDateStr = calender?.dateByAddingComponents(dateComponents, toDate: datetime, options: NSCalendarOptions.allZeros)
            
            UserInfo.MemberendDate = formatter.stringFromDate(changeDateStr!)
            messageBox.showAlert("续费" + toString(self.selectedYear) + "年会员 成功！")
             UserInfo.IsVip = true
            self.navigationController?.popViewControllerAnimated(true)
        }
        else if (resultDic["resultStatus"] as! String) == "6001"
        {
            messageBox.showAlert("支付已取消")
        }
    }
}
