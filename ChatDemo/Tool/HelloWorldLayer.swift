//
//  HelloWorldLayer.swift
//  ChatDemo
//
//  Created by user on 16/1/18.
//  Copyright (c) 2016年 user. All rights reserved.
//

import UIKit
protocol HelloWorldLayerDelegate:NSObjectProtocol
{
    func HelloWorldLayerFinish(orderId:String,code:Int) // code 0:成功 1:失败 2:已经购买过该商品
}
class HelloWorldLayer: CCLayer,SKProductsRequestDelegate,SKPaymentTransactionObserver ,UIAlertViewDelegate{
    var buyType:Int!
    var orderId:String!
    var ProductID_IAP0p99 = "com.dami.mylove.VIP1"    //$0.99
    var ProductID_IAP1p99 = "com.dami.mylove.vip2" //$1.99
    var ProductID_IAP4p99 = "com.dami.mylove.vip3" //$4.99
    var ProductID_IAP9p99 = "com.dami.mylove.vip4" //$19.99
    var ProductID_IAP24p99 = "com.dami.mylove.vip5" //$24.99
    var delegate:HelloWorldLayerDelegate!
    class func scene()->CCScene
    {
        var scene : CCScene = CCScene.node() as! CCScene
        var layer : CCNode = HelloWorldLayer.node() as! CCNode
        scene.addChild(layer)
        return scene;
    }
    
    struct indence {
        static var  indence = HelloWorldLayer()
    }

    func release0() {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(indence.indence)
    }
    
    override init!() {
        super.init()
        //----监听购买结果
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    class func buy(type:Int,orderId:String) {
        indence.indence.buyType = type
        indence.indence.orderId = orderId
        if (SKPaymentQueue.canMakePayments()) {
//            SKPaymentQueue.defaultQueue().restoreCompletedTransactions();
            indence.indence.RequestProductData()
        }
        else
        {
            //            var alerView =  [[UIAlertView alloc] initWithTitle:@"Alert"
            //            message:@"You can‘t purchase in app store（Himi说你没允许应用程序内购买）"
            //            delegate:nil cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil) otherButtonTitles:nil];
            //
            //            [alerView show];
            var alerView = UIAlertView(title: "Alert", message: "You can‘t purchase in app store（你没允许应用程序内购买）", delegate: indence.indence, cancelButtonTitle: "关闭", otherButtonTitles: "确定")
            alerView.show()
        }

    }
    
    func buy(type:Int)
    {
        buyType = type
        if (SKPaymentQueue.canMakePayments()) {
//            SKPaymentQueue.defaultQueue().restoreCompletedTransactions();
            self.RequestProductData()
        }
        else
        {
            var alerView = UIAlertView(title: "Alert", message: "You can‘t purchase in app store（你没允许应用程序内购买）", delegate: self, cancelButtonTitle: "关闭", otherButtonTitles: "确定")
            alerView.show()
        }

    }
    
    func CanMakePay()->Bool
    {
        return SKPaymentQueue.canMakePayments()
    }
    
    func RequestProductData()
    {
        var product :String!
        switch (buyType) {
        case IAP0p99:
            product = ProductID_IAP0p99
            break;
        case IAP1p99:
            product = ProductID_IAP1p99
            break;
        case IAP4p99:
             product = ProductID_IAP4p99
            break;
        case IAP9p99:
            product = ProductID_IAP9p99
            break;
        case IAP24p99:
            product = ProductID_IAP24p99
            break;
            
        default:
            break;
        }
        if ((product) != nil) {
            var set = NSSet(array: [product])
            var request = SKProductsRequest(productIdentifiers: set as Set<NSObject>)
            request.delegate = indence.indence
            request.start()
            BufferView.showGif()
            
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
    }

    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        // populate UI
        var myProduct = response.products;
        for product in myProduct
        {
//            NSLog(@"product info");
//            NSLog(@"SKProduct 描述信息%@", [product description]);
//            NSLog(@"产品标题 %@" , product.localizedTitle);
//            NSLog(@"产品描述信息: %@" , product.localizedDescription);
//            NSLog(@"价格: %@" , product.price);
//            NSLog(@"Product id: %@" , product.productIdentifier);
        }
        var payment:SKPayment = SKPayment(product: myProduct[0] as! SKProduct)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    func requestProUpgradeProductData()
    {
//        CCLOG(@"------请求升级数据---------");
        var productIdentifiers = NSSet(object: "com.productid")
        var productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
//        CCLOG(@"-------弹出错误信息----------");
        switch (error.code)
        {
        case SKErrorUnknown:
            
//            NSLog(@"SKErrorUnknown");
            
            break;
            
        case SKErrorClientInvalid:
            
//            NSLog(@"SKErrorClientInvalid");
            
            break;
            
        case SKErrorPaymentCancelled:
            
//            NSLog(@"SKErrorPaymentCancelled");
            
            break;
            
        case SKErrorPaymentInvalid:
            
//            NSLog(@"SKErrorPaymentInvalid");
            
            break;
            
        case SKErrorPaymentNotAllowed:
            
//            NSLog(@"SKErrorPaymentNotAllowed");
            
            break;
            
        default:
            
//            NSLog(@"No Match Found for error");
            
            break;
            
        }
        
//        NSLog(@"transaction.error.code %@",[transaction.error description]);
        
        var alerView = UIAlertView(title: "Alert", message: error.localizedDescription, delegate: self, cancelButtonTitle: "Close", otherButtonTitles: "确定")
        alerView.show()
    }
    func requestDidFinish(request: SKRequest!) {
//         NSLog(@"----------反馈信息结束--------------");
        
    }
    
    func PurchasedTransaction(transaction:
        SKPaymentTransaction)
    {
//        CCLOG(@"-----PurchasedTransaction----");
        var transactions = NSArray(object: transaction)
        self.paymentQueue(SKPaymentQueue.defaultQueue(), updatedTransactions: transactions as [AnyObject])
    }
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
//        CCLOG(@"-----paymentQueue--------");
        for transaction in transactions
        {
            switch (transaction.transactionState.rawValue)
            {
            case SKPaymentTransactionState.Purchased.rawValue://交易完成
                self.completeTransaction(transaction as! SKPaymentTransaction)
                BufferView.hiden()
//                CCLOG(@"-----交易完成 --------");
//                CCLOG(@"不允许程序内付费购买");
                break;
            case SKPaymentTransactionState.Failed.rawValue://交易失败
                self.failedTransaction(transaction as! SKPaymentTransaction)
                BufferView.hiden()
//                CCLOG(@"-----交易失败 --------");
                break;
            case SKPaymentTransactionState.Restored.rawValue://已经购买过该商品
                self.restoreTransaction(transaction as! SKPaymentTransaction)
                BufferView.hiden()
//                CCLOG(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionState.Purchasing.rawValue:      //商品添加进列表
//                CCLOG(@"-----商品添加进列表 --------");
                break;
            default:
                break;
            }
        }
    }
    /**
    服务器验证
    
    :param: transaction 苹果返回内容编码
    */
    func sendVerification(transaction:SKPaymentTransaction)
    {
        var parameters = ["orderId":indence.indence.orderId]
        AFNetworkTool.postJSONWithUrl(IapNotifyURL, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            }) { (erroe) -> Void in
//                messageBox.showAlert("访问服务器失败")
        }
    }
    
    func completeTransaction(transaction:SKPaymentTransaction)
    {
        sendVerification(transaction)
        //    CCLOG(@"-----completeTransaction--------");
        var product = transaction.payment.productIdentifier
        if (product as NSString).length>0
        {
            self.recordTransaction(product)
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    //成功
    func recordTransaction(product:String)
    {
        indence.indence.delegate.HelloWorldLayerFinish(indence.indence.orderId, code: 0)
    }
    func failedTransaction(transaction:SKPaymentTransaction)
    {
        //    NSLog(@"失败");
        if transaction.error.code != SKErrorPaymentCancelled
        {
            var alerView = UIAlertView(title: "Alert", message: transaction.error.description, delegate: self, cancelButtonTitle: "关闭", otherButtonTitles: "确定")
            alerView.show()
            indence.indence.delegate.HelloWorldLayerFinish(indence.indence.orderId, code: 1)
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        
    }
    func restoreTransaction(transaction:SKPaymentTransaction)
    {
        indence.indence.delegate.HelloWorldLayerFinish(indence.indence.orderId, code: 2)
    }
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
//            CCLOG(@"-------paymentQueue----");
    }
    
}
