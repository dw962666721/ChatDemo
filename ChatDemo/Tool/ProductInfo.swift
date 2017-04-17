//
//  Product.swift
//  DwPayDemo
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

import Foundation

let kNumber = 15;// 商品ID长度
let sourceStr = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; // 商品ID随机字符
protocol ProductInfoDelegate
{
    func productPay(selfInfo:ProductInfo, resultDic:[NSObject : AnyObject]!)
}

class ProductInfo: NSObject ,WXApiDelegate{
    var delegate : ProductInfoDelegate!
    var tradeNO : String!
    var productName : String!
    
    var productDescription : String!
    var amount : String!
    var showUrl = "m.alipay.com"
    var paymentType = "1" // 付款类型 1:（默认）
    var inputCharset = "utf-8" // 数据格式
    var itBPay = "30m" // 截至时间 30分钟
    var rsaDate :String!
    var extraParams : NSMutableDictionary!
    var alert:TFQAlertUtil=TFQAlertUtil()
    override init() {
        super.init()
        alert = TFQAlertUtil()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "complantOrder:", name: "complantOrder", object: nil)
    }
    // 单例
    private struct instance {
        static var instance=ProductInfo()
    }
    class func shareInstance()->ProductInfo{
        return instance.instance
    }
//    func createTradeno(type:Int)->String
//    {
//    if (type == 0)
//    {
//        //微信
//        self.tradeNO = "W"+generateTradeNO()
//        }else
//    {
//        //支付宝
//        self.tradeNO = "Z" + generateTradeNO()
//        }
//        return self.tradeNO
//    }
    func createTradeno(orderNo:String)->String
    {
        self.tradeNO = orderNo
        return self.tradeNO
    }
    func wxPay()
    {
        
        
        //创建支付签名对象
        var req = payRequsestHandler()
        //设置密钥
        //        req.loadKey(WXAppKey, mch_id: MCH_ID)
      
        //获取到实际调起微信支付的参数后，在app端调起支付
        req.setKey(WXAppKey, mch_id: MCH_ID,key: PARTNER_ID, notifyURL: NotifyURL, orderno: self.tradeNO,productDescription:productDescription,amount:amount)
        //获取到实际调起微信支付的参数后，在app端调起支付
        var dict = req.sendPay()
        
        if (dict == nil)
        {
            var debug = req.getDebugifo()
            self.alert.text = debug
        }
        else
        {
            var stamp: AnyObject? = dict.objectForKey("timestamp")
            //调起微信支付
            var req = PayReq()
            req.openID = dict.objectForKey("appid") as! String
            req.partnerId = dict.objectForKey("partnerid") as! String
            req.prepayId = dict.objectForKey("prepayid") as! String
            req.nonceStr  = dict.objectForKey("noncestr") as! String
            req.timeStamp = UInt32(stamp!.doubleValue!)
            req.package = dict.objectForKey("package") as! String
            req.sign  = dict.objectForKey("sign") as! String
            WXApi.sendReq(req)
        }
    }
    
    // 返回随机商品字符串
    func generateTradeNO() -> String
    {
        var resultStr = NSMutableString()
        srand(UInt32(time(nil)));
        for i in 0...kNumber
        {
            var index = rand() % Int32(count(sourceStr))
            var oneStr = (sourceStr as NSString).substringWithRange(NSMakeRange(Int(index), 1))
            resultStr.appendString(oneStr)
        }
        var formatter = NSDateFormatter()
        formatter.dateFormat = "YYYYMMddhhmmssSSS"
        var  today:NSDate = NSDate()
        var dateStr =  formatter.stringFromDate(today)
        dateStr = dateStr.stringByReplacingOccurrencesOfString(":", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
                dateStr = dateStr.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
        return dateStr;
    }
    // 支付宝账单信息
    func aliDescription()->String
    {
        var discription = NSMutableString()
        
        // 支付宝商户号
        if (!Partner.isEmpty&&Partner != "" ) {
            discription.appendFormat("partner=\"%@\"", Partner)
        }
        if (!Seller.isEmpty&&Seller != "") {
            discription.appendFormat("&seller_id=\"%@\"", Seller)
        }
        
        discription.appendFormat("&out_trade_no=\"%@\"", self.tradeNO)
        if (!self.productName.isEmpty&&self.productName != "") {
            discription.appendFormat("&subject=\"%@\"", self.productName)
        }
        if (!self.productDescription.isEmpty&&self.productDescription != "") {
            discription.appendFormat("&body=\"%@\"", self.productDescription)
        }
        if (!self.amount.isEmpty&&self.amount != "") {
            discription.appendFormat("&total_fee=\"%@\"", self.amount)
        }
        if (!NotifyURL.isEmpty&&NotifyURL != "") {
            discription.appendFormat("&notify_url=\"%@\"", NotifyURL)
        }
        if (!AlieServer.isEmpty&&AlieServer != "") {
            discription.appendFormat("&service=\"%@\"", AlieServer)
        }
        if (!self.paymentType.isEmpty&&self.paymentType != "") {
            discription.appendFormat("&payment_type=\"%@\"", self.paymentType)
        }
        if (!self.inputCharset.isEmpty&&self.inputCharset != "") {
            discription.appendFormat("&_input_charset=\"%@\"", self.inputCharset)
        }
        if (!self.itBPay.isEmpty&&self.itBPay != "") {
            discription.appendFormat("&it_b_pay=\"%@\"", self.itBPay)
        }
        if (!self.showUrl.isEmpty && self.showUrl != "") {
            discription.appendFormat("&show_url=\"%@\"", self.showUrl)
        }
        if ((self.rsaDate) != nil) {
            discription.appendFormat("&sign_date=\"%@\"", self.rsaDate)
        }
        if((self.extraParams) != nil)
        {
            for key in self.extraParams.allKeys
            {
                discription.appendFormat("&\"%@\"=\"%@\"", toString(key), toString(self.extraParams.objectForKey(key)))
            }
        }
        return discription as String
    }
    
    func aliPay()
    {
        //将商品信息拼接成字符串 tradeNO
        var orderSpec = aliDescription()
        println("orderSpec = "+orderSpec)
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        var signer = CreateRSADataSigner(privateKey);
        var signedString = signer.signString(orderSpec)
        var orderString = NSMutableString()
        if signedString != nil
        {
            orderString.appendFormat("%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, "RSA")
            //  网页支付宝结果回调
            AlipaySDK.defaultService().payOrder(orderString as String, fromScheme: AppScheme, callback: { (resultDic) -> Void in
                self.complantOrder(resultDic)
            })
        }
    }
    
    // 支付结果完成回调
    func complantOrder(resultDic:[NSObject : AnyObject]!)
    {
        // 支付结果
//      var resultDic = notification.object as [NSObject : AnyObject]!
        ProductInfo.shareInstance().tradeNO = tradeNO
        self.delegate.productPay(self,resultDic: resultDic)
    }
    func onReq(req: BaseReq!) {        
        var strMsg = toString(req.encode())
        //        switch req.encode()
        //        {
        //        case WXSuccess.value:
        //            var resultDic = [NSObject : AnyObject]()
        //            resultDic["resultStatus"]=9000
        //            resultDic["success"]=true
        //            self.delegate.productPay(self,resultDic: resultDic)
        //            break
        //        default:
        //            break
        //        }
    }
    func onResp(resp: BaseResp!) {
        var strMsg = toString(resp.errCode)
        switch resp.errCode
       {
        case WXSuccess.value:
            var resultDic = [NSObject : AnyObject]()
            resultDic["resultStatus"]="9000"
            resultDic["success"]="true"
            self.delegate.productPay(self,resultDic: resultDic)
            break
        case WXErrCodeUserCancel.value:
             alert.text = "操作已被取消"
             alert.showAlert()
            break
        case WXErrCodeSentFail.value:
            alert.text = "请求失败"
            alert.showAlert()
            break
        default:
            break
        }
    }
}
