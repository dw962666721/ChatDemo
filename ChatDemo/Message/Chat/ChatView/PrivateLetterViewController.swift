//
//  PrivateLetterViewController.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class PrivateLetterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DXMessageToolBarDelegate,EMChatManagerChatDelegate,IChatManagerDelegate,ChartImageMessageDelegate,DXChatBarMoreViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,SendImageDelegate,HandleUploadPhotosDelegate,ChartContentDelegate,MFMailComposeViewControllerDelegate{
    var photoImageView:UIImageView!
    var chatTableView:UITableView!
    //    var keyBordView:KeybordView!
    var messageToolBar : DXMessageToolBar!
    var cellFrames:NSMutableArray! // 聊天界面显示的数据
    var userData=["id":"","name":"未知","age":"18","avatarUrl":"mao.png","userNumber":""]
    var conversation:EMConversation!
    var allMessageList:NSMutableArray! // 聊天界面所有的数据
    var index : Int = 0 //消息索引
    var loadCount = 20
    var messageQueue:dispatch_queue_t!
    var vc :SendImageViewController! // 图片发送界面
    //    var messages:[EMMessage]=[]
//     var mailComposeViewController:MFMailComposeViewController!
    var reportVC : ReportViewController! // 举报页面
    /**
    加在对方数据
    */
    func loadMyInformation()
    {
        var userNumber = userData["userNumber"]!
        var parameters = ["usernumber":userNumber]
        AFNetworkTool.postJSONWithUrl(GetUsermesByNumberURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result == "1"
            {
                self.writeMyData(json)
            }
            else
            {
            }
            }) { (error) -> Void in
                
        }
    }
    func writeMyData(myData:[String:AnyObject])
    {
        var  allUserDataList:NSMutableArray!
        // 获取本地所有缓存信息
        var fileManager = NSFileManager.defaultManager()
        
        // 判断沙盒中有没有一个保存与该用户聊天数据的缓存文件
        // 如果有的话  就根据文件的内容去初始化数组
        if fileManager.fileExistsAtPath(GetFilePath.getUserDateListPath())
        {
            // 获取所有用户信息
            allUserDataList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getUserDateListPath()) as! NSMutableArray
        }
        else
        {
            allUserDataList = NSMutableArray()
        }
        
        // 循环所有用户信息 有了则更新 没有 则添加
        var hasSave = false
        for var i = 0 ; i<allUserDataList.count;i++
        {
            var userData = allUserDataList[i] as! [String:AnyObject]
            if (userData["userid"] as! String) == (myData["userid"] as! String)
            {
                allUserDataList[i] = myData
                hasSave = true
            }
        }
        if !hasSave
        {
            allUserDataList.addObject(myData)
        }
        // 保存所有用户信息
        NSKeyedArchiver.archiveRootObject(allUserDataList, toFile: GetFilePath.getUserDateListPath())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageQueue = dispatch_queue_create("easemob.com", nil);
        //        self.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64)
        self.title = userData["name"]
        
        addViews()
        
        initWithData()
        addRefresh()
        // 加载历史聊天记录
        messageList()
        
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        
        // 加在对方数据
        loadMyInformation()
    }
    
    func addViews()
    {
        var rightBtn = UIButton(frame: CGRectMake(0, 0, 40, 22))
        rightBtn.setTitle("举报", forState: UIControlState.Normal)
        rightBtn.addTarget(self, action: "report", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    /**
    举报
    */
    func report()
    {
//        if MFMailComposeViewController.canSendMail()
//        {
//            mailComposeViewController=MFMailComposeViewController()
//            mailComposeViewController.mailComposeDelegate = self;
//            mailComposeViewController.setSubject(self.title! + " 语言违规")
//            mailComposeViewController.setToRecipients(["798833403@qq.com"])
//            setMailMessage(20)
//            navigationController!.topViewController?.presentViewController(mailComposeViewController, animated: true, completion:nil)
//            
//        }
//        else
//        {
//            messageBox.showAlert("请打开邮件发送功能")
//        }
        setMailMessage(20)
        reportVC = ReportViewController()
        reportVC.setData(["userNumber":userData["userNumber"]!,"content":userData["userNumber"]! + "\n" + messageStr,"title":self.title! + " 语言违规","fromEmail":"","toEmail":"798833403@qq.com"])
//        self.presentViewController(reportVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    var messageStr = "" // 举报消息内容
    func setMailMessage(count:Int)
    {
        var messageStr = ""
        var images : [UIImage] = []
        for var i = cellFrames.count - 1 ; i>=0 ; i--
        {
            var chartCellFrame = cellFrames[i] as! ChartCellFrame
            var chatMessage = chartCellFrame.chartMessage
            switch chatMessage.messageStyle
            {
                // 文字
            case 0:
                var textMessage = chatMessage as! ChartTextMessage
                messageStr+=textMessage.content + "  " + textMessage.sendTime + "\n"
                break
                // 图片
            case 1:
                var imageMessage = chatMessage as! ChartImageMessage
                images.append(imageMessage.image)
                break
            default:
                break
            }
        }
        
        self.messageStr = messageStr
//        mailComposeViewController.setMessageBody(messageStr, isHTML: false)
        // 添加图片
        for var i = 0 ; i<images.count;i++
        {
            var imageItem = images[i]
            var imageData = UIImageJPEGRepresentation(imageItem,0.5)
        }
    }
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch (result.value)
        {
        case MFMailComposeResultCancelled.value:
            messageBox.showAlert("邮件发送已取消")
        case MFMailComposeResultSaved.value:
             messageBox.showAlert("邮件已保存")
        case MFMailComposeResultSent.value:
             messageBox.showAlert("邮件已发送")
            sendMessageToUsEmail()
        case MFMailComposeResultFailed.value:
            sendMessageToUsEmail()
            messageBox.showAlert("邮件发送失败")
        default:
            break;
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    func sendMessageToUsEmail()
    {
        var paramers = ["code":userData["userNumber"]! + "\n" + messageStr,"mail":"798833403@qq.com"]
        AFNetworkTool.postJSONWithUrl(SendMailURL, parameters: paramers, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                
            }
            else
            {
                
            }
            
            }, fail: { (error) -> Void in
        })
    }
    func initWithData(){
        
        vc = SendImageViewController()
        
        //根据接收者的username获取当前会话的管理者
        conversation = EaseMob.sharedInstance().chatManager.conversationForChatter!(userData["userNumber"], conversationType: EMConversationType.eConversationTypeChat)
        //        var chatter = conversation.chatter
        self.view.backgroundColor = UIColor(rgbByFFFFFF: 0xB3DBD0)
        //        var tap = UITapGestureRecognizer(target: self, action: "keyBoardHidden")
        //        tap.numberOfTouchesRequired = 1
        //        tap.numberOfTapsRequired=1
        //        self.view.addGestureRecognizer(tap)
        
        self.cellFrames = NSMutableArray()
        self.allMessageList = NSMutableArray()
        
        chatTableView = UITableView(frame: CGRectMake(0, 0, screenWidth, self.view.frame.size.height - 46-64), style: UITableViewStyle.Plain)
        chatTableView.backgroundColor = UIColor(rgbByFFFFFF: 0xB3DBD0)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        chatTableView.registerClass(ChartCell.self, forCellReuseIdentifier: "cell")
        
        //        chatTableView.allowsSelection = false
        self.view.addSubview(chatTableView)
        
        messageToolBar = DXMessageToolBar(frame:  CGRectMake(0, self.view.frame.size.height-46, self.view.frame.size.width, 46))
        messageToolBar.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleRightMargin
        messageToolBar.delegate = self
        var moreView = DXChatBarMoreView(frame: CGRect(x: 0, y: 46, width: messageToolBar.frame.size.width, height: 80), type: ChatMoreTypeChat)
        moreView.delegate=self
        moreView.userInteractionEnabled = true
        messageToolBar.moreView = moreView
        messageToolBar.moreView.backgroundColor = UIColor(red: 240, green: 242, blue: 247, alpha: 1)
        messageToolBar.moreView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        self.view.addSubview(messageToolBar)
        
        
    }
    
    // MARK: -- refresh
    func addRefresh()
    {
        // 下拉刷新
        chatTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "downLoad")
        chatTableView.header.autoChangeAlpha = true
        
        // 上拉刷新
        //        chatTableView.footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "upLoad")
        //        chatTableView.footer.autoChangeAlpha = true
        //        chatTableView.header.beginRefreshing()
    }
    
    func downLoad()
    {
        reloadData()
    }
    func upLoad()
    {
        reloadData()
    }
    func reloadData()
    {
        self.loadLocalMessages(loadCount, index: self.index, append: true)
    }
    // 点击背景隐藏
    func keyBoardHidden()
    {
        messageToolBar.endEditing(true)
        
    }
    // 首次进入聊天页面处理显示消息
    func messageList(){
        // 获取本地所有缓存信息
        var fileManager = NSFileManager.defaultManager()
        
        // 判断沙盒中有没有一个保存与该用户聊天数据的缓存文件
        // 如果有的话  就根据文件的内容去初始化数组
        if fileManager.fileExistsAtPath(GetFilePath.getFilePath(self.conversation.chatter))
        {
            self.allMessageList = NSKeyedUnarchiver.unarchiveObjectWithFile(GetFilePath.getFilePath(self.conversation.chatter)) as! NSMutableArray
        }
        else
        {
            saveFile()
        }
        self.index = self.allMessageList.count
        //加载最后20条暂存在本地的消息
        loadLocalMessages(loadCount,index: self.index,append: false)
        
        // 加载所有未读消息
        if self.conversation.unreadMessagesCount()>0 && !PropertyController.InBalckList(self.conversation.chatter)
        {
            var timestamp = NSDate().timeIntervalSince1970*1000+1
            self.loadMoreMessagesFrom(timestamp, count: Int(self.conversation.unreadMessagesCount()), append: true)
            self.conversation.markAllMessagesAsRead(true)
        }
        
        self.tableViewReload()
        self.tableViewScrollCurrentIndexPath0()
        
    }
    /**保存缓存文件*/
    func saveFile()
    {
        NSKeyedArchiver.archiveRootObject(self.allMessageList, toFile: GetFilePath.getFilePath(self.conversation.chatter))
    }
    /**
    加载本地聊天记录（获取尾部固定条数的数据）
    
    :param: count  获取消息条数
    :param: index  获取索引 (-1代表从尾部获取)
    :param: append 是否累加
    */
    func loadLocalMessages(count:Int,index:Int,append:Bool)
    {
        var oldCount = self.cellFrames.count
        // 所有新创建的cell集合
        var cells  = NSMutableArray()
        if index == 0
        {
            //            self.tableViewReload()
            //            return
        }
        else if self.allMessageList.count<=count
        {
            for message in self.allMessageList
            {
                var dict = objectToDictionary(message)
                var cellFram = creatCellFrame(dict,message: message as! EMMessage)
                cells.addObject(cellFram)
            }
            self.index = 0
        }
        else
        {
            // 消息的开始索引
            var star = self.index-count
            if star < 0
            {
                star = 0
            }
            // 设置全局索引
            if self.index>count
            {
                self.index = self.index-count
            }
            else
            {
                self.index = 0
            }
            // 从开始索引 取出所有本地缓存消息
            for var i = star ; i < index ; i++
            {
                // 如果索引小于0了就设置全局消息索引为零 哈哈哈哈
                if i < 0
                {
                    self.index = 0
                }
                else
                {
                    var dict = objectToDictionary(self.allMessageList[i])
                    var cellFram = creatCellFrame(dict,message: self.allMessageList[i] as! EMMessage)
                    cells.addObject(cellFram)
                }
            }
        }
        if cells.count>0
        {
            var arrayList = self.cellFrames
            self.cellFrames = NSMutableArray()
            for cell in cells
            {
                self.cellFrames.addObject(cell)
            }
            for array in arrayList
            {
                self.cellFrames.addObject(array)
            }
        }
        self.tableViewReload()
        var newCount = self.cellFrames.count
        if oldCount != newCount
        {
            self.chatTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: oldCount==0 ? newCount-oldCount-1:newCount-oldCount, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    /**
    收到消息时的回调
    
    :param: message 消息对象
    */
    func didReceiveMessage(message: EMMessage!) {
        dealMessage(message)
    }
    /**
    收到消息时的回调
    
    :param: message 消息对象
    */
    func didReceiveCmdMessage(cmdMessage: EMMessage!) {
        dealMessage(cmdMessage)
    }
    /**
    处理接收到的消息
    
    :param: message 消息对象
    */
    func dealMessage(message: EMMessage!)
    {
        if PropertyController.InBalckList(message.from)
        {
            return
        }
        self.conversation.markAllMessagesAsRead(true)
        // 将接收到的消息缓存到本地
        localFileAppendMessage(message)
        var dict = objectToDictionary(message)
        var cellFrame = creatCellFrame(dict,message: message)
        self.cellFrames.addObject(cellFrame)
        tableViewReload()
        if self.cellFrames.count>0
        {
            tableViewScrollCurrentIndexPath2()
        }
    }
    func didUnreadMessagesCountChanged() {
        
    }
    // 接受离线消息
    func didReceiveOfflineMessages(offlineMessages: [AnyObject]!) {
        receiveOffLineMessages(offlineMessages)
    }
    func receiveOffLineMessages(offlineMessages: [AnyObject]!)
    {
        if offlineMessages.count == 0
        {
            return
        }
        if self.shouldMarkMessageAsRead()
        {
            self.conversation.markAllMessagesAsRead(true)
        }
        var timestamp = NSDate().timeIntervalSince1970*1000+1
        self.loadMoreMessagesFrom(timestamp, count: offlineMessages.count, append: false)
    }
    /**
    加载环信服务器聊天消息
    
    :param: timestamp 截至时间
    :param: count     获取数量
    :param: append    是否在末端累加
    */
    func loadMoreMessagesFrom(timestamp:Double,count:Int,append:Bool)
    {
        var  messages = self.conversation.loadNumbersOfMessages(UInt(count), before: Int64(timestamp))
        for message in messages
        {
            // 加入到所有聊天记录
            self.allMessageList.addObject(message)
            var dict = objectToDictionary(message)
            if append
            {
                var cellFram = creatCellFrame(dict,message: message as! EMMessage)
                self.cellFrames.addObject(cellFram)
            }
            else
            {
                var cellFram = creatCellFrame(dict,message: message as! EMMessage)
                self.cellFrames.addObject(cellFram)
            }
        }

        // 将消息缓存到本地
        saveFile()
    }
    // 缓存本地数据
    func localFileAppendMessage(obj:AnyObject!)
    {
        self.allMessageList.addObject(obj)
        saveFile()
    }
    /**
    对象准换字典
    
    :param: obj 对象
    
    :returns: 返回 字典
    */
    func objectToDictionary(obj:AnyObject!)->[String : AnyObject]
    {
        var ext = obj.ext as? [String:AnyObject]
        var dateStr = NSDate.formattedTimeFromTimeInterval((obj as! EMMessage).timestamp)
        var senderId : String!
        var receiveId : String!
        var name = obj.from
        var stata = getMessageStata(obj.deliveryState.rawValue)
        
        senderId = obj.from
        receiveId = obj.to
//        if (ext != nil)
//        {
//            if ((ext!.indexForKey("name")) != nil)
//            {
//                name = ext!["name"] as! String
//            }
//            else
//            {
//                name = obj.from
//            }
//        }
        if obj.from == UserInfo.UserNumber
        {
            name = UserInfo.TrueName
        }
        else
        {
            name = self.userData["name"]
        }
        var dict = ["id":obj.messageId,"senderId":senderId,"receiveId":receiveId,"createTime":dateStr,"name":name,"stata":stata]
        var bodis = obj.messageBodies as [AnyObject]
        if bodis.count>0
        {
            var body : IEMMessageBody = bodis.first as! IEMMessageBody
            if body.messageBodyType == MessageBodyType.eMessageBodyType_Text
            {
                dict["message"] =  ConvertToCommonEmoticonsHelper.convertToSystemEmoticons((body as! EMTextMessageBody).text)
                if (ext != nil)
                {
                    if (ext!.indexForKey("message") != nil)
                    {
                        dict["message"] = ext!["message"] as? String
                    }
                }
            }
            else if body.messageBodyType == MessageBodyType.eMessageBodyType_Image
            {
                dict["picture"] = (body as! EMImageMessageBody).remotePath == nil ? "" : (body as! EMImageMessageBody).remotePath
                dict["localImage"] = (body as! EMImageMessageBody).localPath
            }
        }
        return dict
    }
    func getMessageStata(rowValue:Int) ->String
    {
        var stata = "-1"
        switch (rowValue)
        {
        case MessageDeliveryState.eMessageDeliveryState_Pending.rawValue:
            stata = "0"
            break
        case MessageDeliveryState.eMessageDeliveryState_Delivering.rawValue:
            stata = "1"
            break;
        case MessageDeliveryState.eMessageDeliveryState_Delivered.rawValue:
            stata = "2"
            break;
        case MessageDeliveryState.eMessageDeliveryState_Failure.rawValue:
            stata = "3"
            break;
        default:
            break
        }
        return stata
    }
    /**
    发送消息完成回调
    */
    func didSendMessage(message: EMMessage!, error: EMError!) {
        
        if error != nil&&(error.errorCode == EMErrorType.ServerNotLogin||error.errorCode == EMErrorType.ServerNotReachable)
        {
            //注销环信
            EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true, completion:
                {(info,error) -> Void in
                }, onQueue: nil)
            
            EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(UserInfo.UserNumber, password: UserInfo.passWord, completion: {
                (loginInfo,error) -> Void in
                if ((error == nil) && (loginInfo != nil)) {
                    // 设置自动登录
                    (UIApplication.sharedApplication().delegate as! AppDelegate).setAutoLogin()
                    NSNotificationCenter .defaultCenter() .postNotificationName("loadChatList", object: nil);
                }
                }, onQueue: nil)
//             conversation = EaseMob.sharedInstance().chatManager.conversationForChatter!(userData["userNumber"], conversationType: EMConversationType.eConversationTypeChat)

        }
        for var i = 0 ; i<cellFrames.count;i++
        {
            var cell : ChartCellFrame = cellFrames[i] as! ChartCellFrame
            if cell.chartMessage.messageId == message.messageId
            {
                cellFrames[i].chartMessage!.stata = getMessageStata(message.deliveryState.rawValue)
                // 将消息缓存到本地
                localFileAppendMessage(message)
            }
        }
        self.chatTableView.reloadData()
    }
    
    func shouldMarkMessageAsRead()->Bool
    {
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Background
        {
            return false
        }
        return true
    }
    
    // 接受离线透传消息
    func didReceiveOfflineCmdMessages(offlineCmdMessages: [AnyObject]!) {
        if offlineCmdMessages.count == 0
        {
            return
        }
        if self.shouldMarkMessageAsRead()
        {
            self.conversation.markAllMessagesAsRead(true)
        }
        var timestamp = NSDate().timeIntervalSince1970*1000+1
        self.loadMoreMessagesFrom(timestamp, count: offlineCmdMessages.count, append: true)
    }
    func tableViewReload()
    {
        self.chatTableView?.reloadData()
        self.chatTableView.header.endRefreshing()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cellFrames.count
    }
    var tableViewCellList:[ChartCell] = []
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellFrame = self.cellFrames[indexPath.row] as! ChartCellFrame
        //        for cellItem in tableViewCellList
        //        {
        //            if cellItem.cellFrame.isEqual(cellFrame)
        //            {
        //                return cellItem
        //            }
        //        }
        var cell:ChartCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChartCell
        cellFrame.tableView=tableView
        cell.cellFrame = cellFrame
        tableViewCellList.append(cell)
        //        if cell.chartView is ChartImageView{
        cell.chartView.delegate=self
        //        }
        //        else if
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.cellFrames[indexPath.row].cellHeight
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    var selectedMessage:EMMessage!
    func chartContentReSend(message: EMMessage!) {
        var body = message.messageBodies.first as! IEMMessageBody
        if message.deliveryState != MessageDeliveryState.eMessageDeliveryState_Failure
        {
            keyBoardHidden()
            return
        }
        selectedMessage = message
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "重新发送")
        actionSheet.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 // 重新发送
        {
            // 删除聊天记录文件记录
            for var i = 0 ;i<self.allMessageList.count;i++
            {
                var message: EMMessage = self.allMessageList[i] as! EMMessage
                if selectedMessage.messageId == message.messageId
                {
                    self.allMessageList.removeObjectAtIndex(i)
                    saveFile()
                    break;
                }
            }
            // 删除tableView显示聊天记录
            for var j = 0 ; j < self.cellFrames.count;j++
            {
                var cellFram =  cellFrames[j] as! ChartCellFrame
                if cellFram.chartMessage.messageId == selectedMessage.messageId
                {
                    cellFrames.removeObjectAtIndex(j)
                    //                    self.chatTableView.reloadData()
                    break
                }
            }
            var bodis = selectedMessage.messageBodies as [AnyObject]
            var body : IEMMessageBody = bodis.first as! IEMMessageBody
            if body.messageBodyType == MessageBodyType.eMessageBodyType_Text
            {
                var text = ConvertToCommonEmoticonsHelper.convertToSystemEmoticons((body as! EMTextMessageBody).text)
                sendMessage(text, type: 0)
            }
            else if body.messageBodyType == MessageBodyType.eMessageBodyType_Image
            {
                var image = UIImage(contentsOfFile: (body as! EMImageMessageBody).localPath)
                sendMessage(image!, type: 1)
            }
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
    func didSendText(text: String!) {
        // 输入框字符长度>0
        if Int(count(text))>0 && text != "" && text != nil
        {
            sendMessage(text,type: 0)
        }
        else
        {
            var alert:TFQAlertUtil = TFQAlertUtil()
            alert.text = "请输入内容!"
            alert.showAlert()
        }
        
    }
    // type 0: 发送文字 1:发送图片
    func sendMessage(body:NSObject,type:Int)
    {
        // 当前时间
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dataStr = formatter.stringFromDate(NSDate())
        var message:EMMessage!
        if type == 0
        {
            var text = body as! String
            // 发送文字消息
            var dict = ["avatar":UserInfo.userAvatar,"name":UserInfo.TrueName,"avatar0":self.userData["avatarUrl"],"name0":self.userData["name"],"userNumber":UserInfo.UserNumber]
            // 环信发送
            message = ChatSendHelper.sendTextMessageWithString(text, toUsername: self.conversation.chatter, isChatGroup: false, requireEncryption: false, ext: dict)
            
        }
        else
        {
            var image = body as! UIImage
            // 发送图片消息
            var dict = ["avatar":UserInfo.userAvatar,"name":UserInfo.TrueName,"avatar0":self.userData["avatarUrl"],"name0":self.userData["name"],"userNumber":UserInfo.UserNumber]
            message = ChatSendHelper.sendImageMessageWithImage(image, toUsername: self.conversation.chatter, isChatGroup: false, requireEncryption: false, ext: dict)
            //            var msgBody: AnyObject? = message.messageBodies!.first
            //            var body = msgBody as! EMImageMessageBody
            //            dict["picture"] = body.remotePath
            
        }
        addMessae(message)
    }
    func addMessae(message:EMMessage)
    {
        dispatch_async(messageQueue, { () -> Void in
            var dict = self.objectToDictionary(message)
            // 显示发送的文字消息
            var cellFrame = self.creatCellFrame(dict,message: message)
            self.cellFrames.addObject(cellFrame)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableViewReload()
                self.tableViewScrollCurrentIndexPath2()
            })
        })
        
    }
    
    func creatCellFrame(dict:[String : AnyObject]!,message:EMMessage
        )->ChartCellFrame
    {
        var cellFrame = ChartCellFrame()
        var chartMessage = ChartMessage(dictionary: dict)
        if chartMessage.messageType.value == kMessageFrom.value
        {
            chartMessage.icon = self.userData["avatarUrl"]! as String
        }
        if chartMessage.messageType.value == kMessageTo.value
        {
            chartMessage.icon = UserInfo.userAvatar
        }
        if chartMessage is ChartImageMessage{
            (chartMessage as! ChartImageMessage).delegate=self
        }
        
        cellFrame.chartMessage = chartMessage
        cellFrame.chartMessage.message = message
        return cellFrame
    }
    func tableViewScrollCurrentIndexPath()
    {
        if self.cellFrames.count>0
        {
            self.chatTableView.setContentOffset(CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height <= 0 ? -64 : self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height), animated: true)
        }
    }
    
    //让表滚动到某个位置
    func tableViewScrollCurrentIndexPath0()
    {
        if self.cellFrames.count>0
        {
            self.chatTableView.setContentOffset(CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height <= 0 ? 0 : self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height), animated: true)
        }
    }
    func tableViewScrollCurrentIndexPath1()
    {
        if self.cellFrames.count>0
        {
            self.chatTableView.setContentOffset(CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height <= 0 ? -64 : self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height), animated: true)
        }
    }
    func tableViewScrollCurrentIndexPath2()
    {
        if self.cellFrames.count>0
        {
            self.chatTableView.setContentOffset(CGPointMake(0, self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height <= 0 ? 0 : self.chatTableView.contentSize.height-self.chatTableView.bounds.size.height), animated: true)
        }
    }
    // 发送图片
    func moreViewPhotoAction(moreView: DXChatBarMoreView!) {
        HandleUploadPhotos.photoPicker(currentViewController: self, delegate: self, allowsEditing: false)
        
    }
    func imagePickerControllerDidFinishPickingMediaWithInfo(image: UIImage) {
        finishPhoto(image)
    }

    // 显示确认发送图片界面
    func finishPhoto(image:UIImage)
    {
        vc.delegate = self
        vc.setImageItem(image)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func sendImage(image: UIImage) {
        sendMessage(image, type: 1)
    }
    // 发送语音
    func moreViewAudioCallAction(moreView: DXChatBarMoreView!) {
        
    }
    // 发送地理位置
    func moreViewLocationAction(moreView: DXChatBarMoreView!) {
        
    }
    // 调用相机
    func moreViewTakePicAction(moreView: DXChatBarMoreView!) {
        
    }
    // 发送视频
    func moreViewVideoCallAction(moreView: DXChatBarMoreView!) {
        
    }
    var selectedImageView:UIImageView!
    
    
    func didChangeFrameToHeight(toHeight: CGFloat) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var rect = self.chatTableView.frame
            rect.origin.y=0
            rect.size.height = self.view.frame.size.height - toHeight
            self.chatTableView.frame = rect
        })
        if self.cellFrames.count>0
        {
            tableViewScrollCurrentIndexPath2()
        }
    }
    
    func imageDidDownLoad() {
        tableViewReload()
        tableViewScrollCurrentIndexPath2()
    }
    
    // 图片浏览的代理方法
    func chartContentBrowsePhotos(imageView: UIImageView!, id messageId: String!) {
//        var testView = imageView.copy() as! UIImageView
//        testView.frame.origin.y += testView.frame.size.height/2
        selectedImageView = imageView
        var pickerBrowser = ZLPhotoPickerBrowserViewController()
        pickerBrowser.delegate = self
        pickerBrowser.dataSource = self
        pickerBrowser.currentIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        pickerBrowser.show()        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension PrivateLetterViewController:ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate
{
    func numberOfSectionInPhotosInPickerBrowser(pickerBrowser: ZLPhotoPickerBrowserViewController!) -> Int {
        return 1
    }
    func photoBrowser(photoBrowser: ZLPhotoPickerBrowserViewController!, numberOfItemsInSection section: UInt) -> Int {
        return 1
    }
    func photoBrowser(pickerBrowser: ZLPhotoPickerBrowserViewController!, photoAtIndexPath indexPath: NSIndexPath!) -> ZLPhotoPickerBrowserPhoto! {
        var imageObj = selectedImageView.image
        var photo = ZLPhotoPickerBrowserPhoto(anyImageObjWith: imageObj)
        photo.toView = selectedImageView
        photo.thumbImage = selectedImageView.image
        return photo
    }
    func photoBrowserDidMiss() {
        if messageToolBar.frame.size.height != DXMessageToolBar.defaultHeight()
        {
            messageToolBar.becomeFirstResponder()
        }
        
    }
    
}