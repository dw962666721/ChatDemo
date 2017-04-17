//
//  EditInformationViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/7.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class EditInformationViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ChooseViewDatasource,UIActionSheetDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HandleUploadPhotosDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UITextViewDelegate{
    @IBOutlet weak var bottomView: UIView! // 底部操作View
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatBtn: UIButton!// 会话按钮
    @IBOutlet weak var addFrendBtn: UIButton! // 添加好友按钮
    @IBOutlet weak var chatConstraint: NSLayoutConstraint!//会话按钮宽度

    @IBOutlet weak var mainScroolView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint! // 相册的高度
    @IBOutlet weak var collectionView: UICollectionView! // 相册
    
    @IBOutlet weak var vipViewH: NSLayoutConstraint!
    
    @IBOutlet weak var nameConstraintT: NSLayoutConstraint!
    @IBOutlet weak var vipTextFiled: UITextField! //会员名称
    @IBOutlet weak var vipImageView: UIImageView! // 会员图标
    @IBOutlet weak var nameLabel: UITextField! // 昵称
    
    @IBOutlet weak var trueNameTextFiled: UITextField!// 真实姓名
    
    @IBOutlet weak var qqAndTelTextFiled: UIView! // 盛放qq和电话
    @IBOutlet weak var qqAndTelT: NSLayoutConstraint!
    @IBOutlet weak var qqAndTelH:
    NSLayoutConstraint! // 的view
    @IBOutlet weak var remarkT: NSLayoutConstraint! // 签名顶部约束
    
    @IBOutlet weak var qqTextFiled: UITextField!//qq
    
    @IBOutlet weak var telTextFiled: UITextField!// 手机号
    
    @IBOutlet weak var telBtn: UIButton! // 拨打手机
    @IBOutlet weak var dateChooseView: DateChooseView! // 年龄
    
    @IBOutlet weak var ageTextFiled: UITextField! // 年龄
    @IBOutlet weak var sexChooseView: ChooseViewStyleClearDown! // 性别
    @IBOutlet weak var figureChooseView: ChooseViewStyleClearDown! // 身材
    @IBOutlet weak var loveTextFiled: UITextField!// 爱好
    @IBOutlet weak var jobTextFiled: UITextField! // 职业
    @IBOutlet weak var areaTextFiled: UITextField!
    
    @IBOutlet weak var areaChooseView: LocationChooseViewGroup! // 地址
    
    // 签名水平位置
    @IBOutlet weak var remarkTextView: XHMessageTextView!//签名
    
    @IBOutlet weak var remarkViewHeightConstraint: NSLayoutConstraint! // 签名View的高度
    @IBOutlet weak var remarkHeightConstraint: NSLayoutConstraint! //签名高度
    var imageArray:[[String:AnyObject]]=[[String:AnyObject]]() // 图片数组
    var myData:[String:AnyObject]!//我的资料
    var bufferDataDict:[String:UIImage]=[String:UIImage]()// 缓存图片字典
    var userId:String!
    var viewPhoto:UIImageView!//图片浏览的启动View
    var saveAlertView:UIAlertView!// 保存信息对话框
    var joinVipAlertView:UIAlertView! // 成为会员对话框
    var isFriend:Bool=false// 是否是好友
    var delActionSheet:UIActionSheet! // 删除图片提示框
    var telActionSheet:UIActionSheet! // 打电话提示框
    var qqActionSheet:UIActionSheet! // 拷贝QQ号码提示框
    var browClick = false; // 是否点击浏览了
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        NSBundle.mainBundle().loadNibNamed("EditInformationViewController", owner: self, options: nil)[0]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: "loadData", object: nil)
        
        setStyle()
        
        setDelegate()
        
        loadDataImage()
        
        loadMyInformation()
    }
    func loadData()
    {
        loadDataImage()
        
        loadMyInformation()
    }
    func loadHistoryData() -> Bool
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
            if (userData["userid"] as! String) == userId
            {
                myData = allUserDataList[i] as! [String : AnyObject]
                self.writeMyData()
                return  true
            }
        }
        return false
    }
    func loadMyInformation()
    {
//        bufferInfoView.show(self.view)
        var hasData = false
        var parameters = ["userid":UserInfo.userID]
        if (userId != nil)
        {
            parameters["beid"] = userId
            hasData = loadHistoryData()
        }
        if !hasData
        {
            bufferInfoView.show(self.view)
        }
        AFNetworkTool.postJSONWithUrl((userId == nil || userId == UserInfo.userID) ? GetMyDataURL:GetUserDataURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result == "1"
            {
                self.myData = json
                self.writeMyData()
            }
            else
            {
//                messageBox.showAlert(json["msg"] as! String)
            }
            if !hasData
            {
                bufferInfoView.hiden()
            }
        }) { (error) -> Void in
            if !hasData
            {
                bufferInfoView.hiden()
                messageBox.showAlert("访问数据库失败")
            }
        }
    }
    func writeMyData()
    {
        if let name = myData["username"] as? String
        {
            nameLabel.text = name
        }
        if let trueName = myData["truename"] as? String
        {
            trueNameTextFiled.text = trueName
        }
        if let age = myData["age"] as? String
        {
            ageTextFiled.text = age
        }
        if let sex = myData["sex"] as? String
        {
            sexChooseView.value = sex=="1" ? "男":"女"
        }
        if let figure = myData["figure"] as? String
        {
            figureChooseView.value = figure
        }
        if let hobby = myData["hobby"] as? String
        {
            loveTextFiled.text = hobby
        }
        if let professional = myData["professional"] as? String
        {
            jobTextFiled.text = professional
        }
        if let mark = myData["mark"] as? String
        {
            remarkTextView.text = mark
        }
        if remarkTextView.numberOfLinesOfText() <= 1
        {
            remarkHeightConstraint.constant = 8
        }
        else
        {
            remarkHeightConstraint.constant = 0
        }
        remarkViewHeightConstraint.constant = getTextViewContentH(remarkTextView)
        var areaStr=""
        if let pro = myData["pro"] as? String
        {
            areaChooseView.selectedProName = pro
            areaStr+=pro
        }
        if let city = myData["city"] as? String
        {
            areaChooseView.selectedCity = city
            areaStr+=city
        }
        if let county = myData["county"] as? String
        {
            areaChooseView.selectedRegion = county
            areaStr+=county
        }
        areaTextFiled.text = areaStr
        if let qq = myData["qq"] as? String
        {
            qqTextFiled.text = (qq == "0" ? "暂无权限" : qq)
        }
        if let tel = myData["tel"] as? String
        {
            telTextFiled.text = (tel == "0" ? "暂无权限" : tel)
        }
        if let isfriend = myData["isfriend"] as? String
        {
            isFriend = (isfriend == "1" ? true : false)
        }
        // 会员设置
        vipTextFiled.text = UserInfo.VipName
        if UserInfo.IsVip
        {
            vipImageView.image = UIImage(named: "vip1")
            vipTextFiled.textColor = UIColor.redColor()
        }
        else
        {
            vipImageView.image = UIImage(named: "vip1_disable")
            vipTextFiled.textColor = UIColor.grayColor()
        }
        var memberlevel=""
        if myData["qq"] as? String == "0"
        {
            if myData["tel"] as? String == "0"
            {
                memberlevel = "0"
            }
        }
        else
        {
            if myData["tel"] as? String == "0"
            {
                memberlevel = "1"
            }
            else
            {
                memberlevel = "2"
            }
        }
//        // 会员权限
//        if memberlevel != ""
//        {
//            if memberlevel == "0"
//            {
//               remarkT.constant = -88
//            }
//            else if memberlevel == "1"
//            {
//                remarkT.constant = -43
//            }
//            else if memberlevel == "2"
//            {
//                remarkT.constant = 1
//            }
//        }
//        else
//        {
//            remarkT.constant = -88
//        }
        // 如果是自己 则隐藏底部的View
        if (userId != nil && userId == UserInfo.userID) || userId == nil
        {
            bottomView.hidden = true
            // 设置scrollView的contentSize
            bottomViewConstraint.constant = 0
        }
        else
        {
            // 设置scrollView的contentSize
            bottomViewConstraint.constant = 40
            if let isFriend = myData["isfriend"] as? String
            {
                chatConstraint.constant = (isFriend == "1" ? screenWidth : screenWidth/2)
            }
        }
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
        
        if userId == nil
        {
            self.title = "编辑资料"
        }
        else
        {
            self.title = PropertyController.getNameById(userId)
        }
    }
    func setDelegate()
    {
        var tap = UITapGestureRecognizer(target: self, action: "touchTap")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
        
        nameLabel.delegate = self
        trueNameTextFiled.delegate = self
        loveTextFiled.delegate = self
        jobTextFiled.delegate = self
        remarkTextView.delegate = self
        
        sexChooseView.datasource = self
        figureChooseView.datasource = self
        dateChooseView.datasource = self
        
        collectionView.registerNib(UINib(nibName: "imagecollectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyBord:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyBord:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
   
    func setStyle()
    {
        
        var maxDate = NSDate(daysBeforeNow: 365*18)
        dateChooseView.maxdate = maxDate
        
        delActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "删除")
        
        telActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拨打电话")
        
        qqActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拷贝")
        
        nameLabel.limitTextLength(8)
        
        remarkTextView.placeHolder = "暂无"
        remarkTextView.placeHolderTextColor = UIColor.lightGrayColor()
        remarkHeightConstraint.constant = 8
        
        loveTextFiled.limitTextLength(15)
        jobTextFiled.limitTextLength(15)
        
        
        viewPhoto = UIImageView(frame: CGRect(x: (screenWidth-70)/2, y: 150, width: 70, height: 70))
        viewPhoto.hidden = true
        self.view.addSubview(viewPhoto)
        
        var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        var wid : CGFloat = 74
        if IS_IPHONE_6
        {
            wid = 88
        }
        if IS_IPHONE_6P
        {
            wid = 97
        }
        flowLayout.itemSize = CGSizeMake(wid, wid)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 5, right: 4)
        collectionView.collectionViewLayout = flowLayout
        
        // 缓冲页面
//        bufferView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
//        bufferView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
//        var activity = UIActivityIndicatorView(frame: CGRect(x: (screenWidth-50)/2, y: (screenHeight-50)/2, width: 50, height: 50))
//        activity.startAnimating()
//        
//        bufferView.hidden = true
//        bufferView.addSubview(activity)
//        self.view.addSubview(bufferView)
        
         saveAlertView = UIAlertView(title:"", message: "放弃对资料的修改？", delegate: self, cancelButtonTitle: "继续编辑", otherButtonTitles: "放弃")
        
       
        if (userId != nil)  // 浏览
        {
            if userId == UserInfo.userID // 浏览自己的信息
            {
                var rightBar = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: "EditAction")
                rightBar.tintColor = UIColor.whiteColor()
                self.navigationItem.setRightBarButtonItem(rightBar, animated: false)
            }
            else // 浏览他人的信息
            {
                // 看不到对方会员级别
                nameConstraintT.constant = -44
            }
            nameLabel.userInteractionEnabled = false
            trueNameTextFiled.userInteractionEnabled = false
            remarkTextView.userInteractionEnabled = false
            qqTextFiled.userInteractionEnabled = false
            telTextFiled.userInteractionEnabled = false
            ageTextFiled.userInteractionEnabled = false
            sexChooseView.userInteractionEnabled = false
            figureChooseView.userInteractionEnabled = false
            loveTextFiled.userInteractionEnabled = false
            jobTextFiled.userInteractionEnabled = false
            areaChooseView.userInteractionEnabled = false
            areaTextFiled.userInteractionEnabled = false
            dateChooseView.userInteractionEnabled = false
            areaTextFiled.hidden = false
            areaChooseView.hidden = true
            
            //
            
        }
        else // 编辑自己的资料
        {
            // 看不到自己的会员级别
            nameConstraintT.constant = -44
            areaTextFiled.hidden = true
            areaChooseView.hidden = false
            
            qqTextFiled.userInteractionEnabled = false
            telTextFiled.userInteractionEnabled = false
            
            var leftBar = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelAction")
            leftBar.tintColor = UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem = leftBar
            
            var rightBar = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
            rightBar.tintColor = UIColor(rgbByFFFFFF: 0x0079FD)
             self.navigationItem.setRightBarButtonItem(rightBar, animated: false)
        }
    }
    func loadDataImage()
    {
//        if userId != nil && userId != UserInfo.userID
//        {
//            self.imageArray = json["photolist"] as! [[String:AnyObject]]
//            self.collectionView.reloadData()
//            return
//        }
//        bufferInfoView.show(self.view)
        self.imageArray = PropertyController.getUserImageList(userId != nil ? userId : UserInfo.userID)
        self.collectionView.reloadData()
        var parameters = ["userid":userId != nil ? userId : UserInfo.userID];
        AFNetworkTool.postJSONWithUrl(GetMyphotoURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result == "1"
            {
                self.imageArray = json["photolist"] as! [[String:AnyObject]]
                self.collectionView.reloadData()
                PropertyController.insertUserImageList(self.userId != nil ? self.userId : UserInfo.userID, imageListData: self.imageArray)
            }
            else
            {
                messageBox.showAlert(json["msg"] as! String)
            }
//            bufferInfoView.hiden()
        }) { (error) -> Void in
            messageBox.showAlert("访问服务器失败")
//            bufferInfoView.hiden()
        }
    }
    func chooseView(chooseView: ChooseView!, numberOfRowsInComponent componen: Int) -> Int {
        if chooseView == sexChooseView
        {
            return 2
        }
        else
        {
            return manFigure.count
        }
    }
    func numberOfComponentsInChooseView(chooseView: ChooseView!) -> Int {
        return 1
    }
    func chooseView(chooseView: ChooseView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if chooseView == sexChooseView
        {
            return sexArray[row]
        }
        else
        {
            if sexChooseView.value=="男"
            {
                return manFigure[row]
            }
            else
            {
                return womenFigure[row]
            }
        }

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count:Int
        if (userId != nil)
        {
            count = imageArray.count
        }
        else
        {
            if imageArray.count<12
            {
                count = imageArray.count+1
            }
            else
            {
                count = imageArray.count
            }
        }
        
        if count>8
        {
            var collectionH :CGFloat = 240
            if IS_IPHONE_6
            {
                collectionH = 283
            }
            if IS_IPHONE_6P
            {
                collectionH = 310
            }
            collectionHeightConstraint.constant = collectionH
        }
        else if count>0
        {
            collectionHeightConstraint.constant = 170
        }
        else
        {
             self.collectionHeightConstraint.constant = 0
        }
        return count
    }
    var selectedIndex : Int = -1
    var selectedImage:UIImage!
//    func collec
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (imageArray.count == indexPath.row)
        {
            // 添加图片
            HandleUploadPhotos.photoPicker(currentViewController: self, delegate: self, allowsEditing: true)
        }
        else
        {
            if (userId != nil)
            {
                // 预览
                touchTap()
                var cell = collectionView.cellForItemAtIndexPath(indexPath) as! imagecollectionCollectionViewCell
                var rect = cell.frame
                rect.origin.y += 40
                viewPhoto.frame = rect
                selectedImage = cell.img.image
                
                selectedIndex = indexPath.row
                var pickerBrowser = ZLPhotoPickerBrowserViewController()
                pickerBrowser.delegate = self
                pickerBrowser.dataSource = self
                pickerBrowser.currentIndexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
                pickerBrowser.show()
                browClick = true
            }
            else
            {
                delActionSheet.showInView(self.view)
                delIndex = indexPath.row
            }
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!imagecollectionCollectionViewCell
        if (imageArray.count > indexPath.row)
        {
            var imageID = imageArray[indexPath.row]["imgid"] as! String
            if (bufferDataDict[imageID] != nil)
            {
                cell.setImage(bufferDataDict[imageID]!)
            }
            else
            {
                var imageStr = imageArray[indexPath.row]["img"] as! String
                cell.setImageStr(imageStr)
            }
        }else
        {
            //设置添加图片
            cell.img.image = UIImage(named: "上传")
        }
        return cell
        
    }
    var delIndex = -1
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            if actionSheet == delActionSheet
            {
                if delIndex<0
                {
                    return
                }
                // 删除图片
                delImage(delIndex)
            }
            else if actionSheet == telActionSheet
            {
                UIApplication.sharedApplication().openURL(NSURL(string:"tel://" + telTextFiled.text)!)
            }
            else
            {
                var pasteboard = UIPasteboard.generalPasteboard()
                pasteboard.string = qqTextFiled.text
                messageBox.showAlert("复制成功")
            }
        }
    }
    
    func delImage(index:Int)
    {
        var id = imageArray[index]["imgid"] as! String
        var parameters = ["imgid":id];
        AFNetworkTool.postJSONWithUrl(DelphotoURL, parameters: parameters, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result == "1"
            {
                self.imageArray.removeAtIndex(index)
                self.bufferDataDict[id] = nil
                self.collectionView.reloadData()
            }
            else
            {
                messageBox.showAlert(json["msg"] as! String)
            }
            }) { (error) -> Void in
                messageBox.showAlert("删除图片未成功0")
        }
    }
    
    func imagePickerControllerDidFinishPickingMediaWithInfo(image: UIImage)
    {
        //上传图片
        bufferInfoView.show(self.view)
        var parameters = ["userid":UserInfo.userID,"type":"png"]
        AFNetworkTool.postUploadWithData(AddphotoURL, parameters: parameters, fileData: UIImagePNGRepresentation(image), filename: "img", success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String:AnyObject]
            var result = json!["res"] as! String
            if result == "1"
            {
                var imageUrl = json!["msg"] as! String
                var dict = ["imgid":json!["ID"] as! String,"img":imageUrl]
                self.bufferDataDict[json!["ID"] as! String] = image // 缓存图片
                self.imageArray.append(dict)
//                self.imageArray.insert(dict, atIndex: self.imageArray.count)
                self.collectionView.reloadData()
//                messageBox.showAlert("上传成功！")
            }
            else
            {
                messageBox.text = json!["msg"] as! String
                messageBox.showAlert()
            }
            bufferInfoView.hiden()
            }, fail: { () -> Void in
                messageBox.text = "上传图片失败"
                messageBox.showAlert()
                bufferInfoView.hiden()
        })

    }
    func chooseViewSureButtonClicked(chooseView: ChooseView!) {
        if chooseView != dateChooseView
        {
            return
        }
        var value = chooseView.value
        if value == ""
        {
            ageTextFiled.text="0"
        }
        var famater = NSDateFormatter()
        famater.dateFormat = "yyyy-MM-dd"
        var date = famater.dateFromString(value)!
        var nowDate = NSDate()
        if date.year <= nowDate.year
        {
            if date.month <= nowDate.month
            {
                if date.day <= nowDate.day
                {
                    ageTextFiled.text = toString(nowDate.year - date.year + 1)
                }
                else
                {
                    ageTextFiled.text = toString(nowDate.year - date.year)
                }
            }
            else
            {
                ageTextFiled.text = toString(nowDate.year - date.year)
            }
        }
        else
        {
            ageTextFiled.text="0"
        }

    }
    
    func EditAction()
    {
        var vc = EditInformationViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**
    保存个人信息
    */
    func save()
    {
        if !verification()
        {
            return
        }
        bufferInfoView.show(self.view)
        var paramers = getParamers()
        AFNetworkTool.postJSONWithUrl(UpdateDataURL, parameters: paramers, success: { (jsonData) -> Void in
            var json = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = json["res"] as! String
            if result == "1"
            {
                messageBox.showAlert("保存成功")
                self.navigationController?.popViewControllerAnimated(true)
                UserInfo.TrueName = self.trueNameTextFiled.text
                UserInfo.userName = self.nameLabel.text
                NSNotificationCenter.defaultCenter().postNotificationName("loadData", object: nil)
            }
            else
            {
                messageBox.showAlert(json["msg"] as! String)
            }
             bufferInfoView.hiden()
        }) { (error) -> Void in
             messageBox.showAlert("访问服务器失败")
            bufferInfoView.hiden()
             self.navigationController?.popViewControllerAnimated(true)
        }
       
    }
    func verification()->Bool
    {
        var result = true
        if nameLabel.text.isEmpty
        {
            result = false
            messageBox.showAlert("昵称不能为空")
        }
        else if ageTextFiled.text.isEmpty
        {
            result = false
            messageBox.showAlert("年龄不能为空")
        }
        else if ageTextFiled.text.toInt()<0 || ageTextFiled.text.toInt()>100
        {
            result = false
            messageBox.showAlert("年龄范围为0˜100")
        }
        return result
    }
    func getParamers()->[String:AnyObject]
    {
        var paramers = [String:AnyObject]()
        paramers["userid"] = UserInfo.userID
        paramers["truename"] = trueNameTextFiled.text
        paramers["username"] = nameLabel.text
        paramers["age"] = ageTextFiled.text
        paramers["sex"] = (sexChooseView.value=="男" ? "1":"0")
        paramers["figure"] = figureChooseView.value
        paramers["hobby"] = loveTextFiled.text
        paramers["professional"] = jobTextFiled.text
        paramers["mark"] = remarkTextView.text
        paramers["pro"] = areaChooseView.province
        paramers["city"] = areaChooseView.city
        paramers["county"] = areaChooseView.region
        return paramers
    }
    // 成为会员
    @IBAction func joinMemberAction(sender: AnyObject) {
        pushMemberPayView()
    }
    // 拷贝QQ号码
    @IBAction func qqAction(sender: AnyObject) {
        if VerificatePhoneFormat.verificateNumber(qqTextFiled.text)
        {
            qqActionSheet.showInView(self.view)
        }
        else if telTextFiled.text == "暂无权限"
        {
            showJoinVipBox("需要成为会员查看对方QQ,是否成为会员？")
        }
    }

    // 拨打电话
    @IBAction func telAction(sender: AnyObject) {
        if VerificatePhoneFormat.verificatePhoneFormat(telTextFiled.text)
        {
            telActionSheet.showInView(self.view)
        }
        else if telTextFiled.text == "暂无权限"
        {
            showJoinVipBox("需要成为会员获取到对方联系方式,是否成为会员？")
        }
    }
    func cancelAction()
    {
        saveAlertView.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0
        {
            
        }
        else
        {
            if saveAlertView == alertView
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
            else
            {
               pushMemberPayView()
            }
        }
    }
    func pushMemberPayView()
    {
        var vc:UIViewController!
        //                if UserInfo.isLogin
        //                {
        vc = ChooseVipViewController()
        //                }
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    /**
    会话
    */
    @IBAction func chatAction(sender: AnyObject) {
        if UserInfo.IsVip || isFriend
        {
            chat()
        }
        else
        {
            showJoinVipBox("需要成为会员才能聊天,是否成为会员？")
        }
    }
    func chat()
    {
//        var conversation = EaseMob.sharedInstance().chatManager.conversationForChatter!(myData["usernumber"] as! String, conversationType: EMConversationType.eConversationTypeChat)
        if (myData != nil)
        {
        var vc = PrivateLetterViewController()
        vc.userData = ["id":userId,"name":PropertyController.getNameById(userId),"age":myData==nil ? "" : myData["age"] as! String,"avatarUrl":myData==nil ? "" : myData["avatar"] as! String,"userNumber": myData["usernumber"] as! String]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    /**
    添加好友
    */
    @IBAction func addFrendAction(sender: AnyObject) {
        if UserInfo.IsVip
        {
            addFriend()
        }
        else
        {
           showJoinVipBox("需要成为会员才能添加好友,是否成为会员？")
        }
    }
    func showJoinVipBox(str:String)
    {
        joinVipAlertView = UIAlertView(title: "", message:str , delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "成为会员")
        joinVipAlertView.show()
    }
    func addFriend()
    {
        bufferInfoView.show(self.view)
        var parameters = ["userid":UserInfo.userID,"friendid":userId]
        AFNetworkTool.postJSONWithUrl(AddFriendAskURL, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                messageBox.showAlert("添加请求已发送！")
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }
            bufferInfoView.hiden()
            }) { (error) -> Void in
                bufferInfoView.hiden()
                messageBox.showAlert("添加请求发送未成功0")
        }
    }
    func touchTap()
    {
         self.view.endEditing(true)
    }
    var keyBordH :CGFloat = 240
    func showKeyBord(notif:NSNotification)
    {
        var rect = (notif.userInfo! as NSDictionary)[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        keyBordH = rect.height-90
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frame =  self.mainScroolView.frame
            frame.origin.y = -self.keyBordH
            self.mainScroolView.frame = frame
            self.bottomViewConstraint.constant = 90 + self.getTextViewContentH(self.remarkTextView)
        })
    }
    func chooseViewPickerWillShow(chooseView: ChooseView!) {
        touchTap()
    }
    func hideKeyBord(notif:NSNotification)
    {
        var rect = (notif.userInfo! as NSDictionary)[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
        keyBordH = rect.height-90
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var frame =  self.mainScroolView.frame
            frame.origin.y = 0
            self.mainScroolView.frame = frame
            self.bottomViewConstraint.constant = 0
            
        })
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView == remarkTextView
        {
            if remarkTextView.numberOfLinesOfText() <= 1
            {
                remarkHeightConstraint.constant = 8
            }
            else
            {
                remarkHeightConstraint.constant = 0
            }
            remarkViewHeightConstraint.constant = getTextViewContentH(remarkTextView)
        }
    }
    func getTextViewContentH(textView:UITextView)->CGFloat
    {
        if (textView.text == "")
        {
            (textView as! XHMessageTextView).placeHolder = "暂无"
        }
        else
        {
            (textView as! XHMessageTextView).placeHolder = ""
        }
        if SystemVersion>=7
        {
            return ceil(textView.sizeThatFits(textView.frame.size).height) + remarkHeightConstraint.constant
        }
        else
        {
            return textView.contentSize.height + remarkHeightConstraint.constant
        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
       touchTap()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     var imagePhotos:[ZLPhotoPickerBrowserPhoto]=[]
}
extension EditInformationViewController:ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate
{
    func numberOfSectionInPhotosInPickerBrowser(pickerBrowser: ZLPhotoPickerBrowserViewController!) -> Int {
        return 1
    }
    func photoBrowser(photoBrowser: ZLPhotoPickerBrowserViewController!, numberOfItemsInSection section: UInt) -> Int {
        return imageArray.count
    }
   
    func photoBrowser(pickerBrowser: ZLPhotoPickerBrowserViewController!, photoAtIndexPath indexPath: NSIndexPath!) -> ZLPhotoPickerBrowserPhoto! {
        
        var imageObj = NSURL(string: ServerURL + (imageArray[indexPath.row]["img"] as! String))
        var photo = ZLPhotoPickerBrowserPhoto(anyImageObjWith: imageObj)
        if (collectionView.cellForItemAtIndexPath(indexPath) != nil)
        {
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as! imagecollectionCollectionViewCell
            var rect = cell.frame
            rect.origin.y += 70
            viewPhoto.frame = rect
            photo.thumbImage = cell.img.image
        }
        photo.toView = viewPhoto
        // imagePhotos.append(photo)
        return photo
    }
}


