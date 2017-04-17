//
//  NearPersonsViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/9.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class NearPersonsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,ChooseViewDatasource,ChooseViewGroupDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate{
    
    @IBOutlet weak var sexWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainFigureView: UIView!
    @IBOutlet weak var ageLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sexView: UIView!
    @IBOutlet weak var allSexBtn: UIButton!
    @IBOutlet weak var manSexBtn: UIButton!
    @IBOutlet weak var womenSexBtn: UIButton!
    
    @IBOutlet weak var allFigureView: UIView!
    
    @IBOutlet weak var manFigureView: UIView!
    
    @IBOutlet weak var womenFigureView: UIView!
    
    @IBOutlet weak var ageMinChooseView: ChooseViewStyleClearDown!
    @IBOutlet weak var ageMaxChooseView: ChooseViewStyleClearDown!
    
    @IBOutlet weak var adressChooseViewGroup: LocationChooseViewGroup!
    var dataArray:[[String:AnyObject]]=[]
    var locationManager:CLLocationManager!
    var geoCodeSearch:BMKGeoCodeSearch!
    func reloadData(page:Int=0)
    {
        var parameters = getParameters(page)
        AFNetworkTool.postJSONWithUrl(GetUserListURL, parameters: parameters, success: { (jsonData) -> Void in
            var data = NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: NSJSONReadingOptions.allZeros, error: nil) as! [String:AnyObject]
            var result = data["res"] as! String
            if result == "1"
            {
                var dataList = data["userlist"] as! [[String:AnyObject]]
                if page == 0
                {
                    self.dataArray = dataList
                }
                else
                {
                    self.dataArray = self.dataArray + dataList
                }
                self.tableView.reloadData()
            }
            else
            {
                messageBox.showAlert(data["msg"] as! String)
            }            
            self.tableView.header.endRefreshing()
            self.tableView.footer.endRefreshing()
            
        }) { (error) -> Void in
            messageBox.showAlert("未获取到帅哥美女数据。。。。")
            self.tableView.header.endRefreshing()
            self.tableView.footer.endRefreshing()
        }
    }
//    var sexType = 2 // 性别 1－男 0-女 2全部
    func getParameters(page:Int)->[String:AnyObject]
    {
        var result = [String:AnyObject]()
        // 获取省市区
        var proName = (adressChooseViewGroup.province=="省份") ? "" : adressChooseViewGroup.province
        var city = adressChooseViewGroup.city=="城市" ? "" : adressChooseViewGroup.city
        var county = adressChooseViewGroup.region=="区域" ? "" : adressChooseViewGroup.region
        var dict = ["proName":proName,"city":city,"region":county];
        NSUserDefaults.standardUserDefaults().setObject(dict, forKey: lastLocation)
        
        // 获取性别
        var sex = toString(sexView.tag - 990) // 性别 1－男 0-女 2全部
        // 获取身材
        var figure = ""
        if sex == "2"
        {
            figure = ""
        }
        else if sex == "1"
        {
           figure = manFigure[manFigureView.tag-1000]
        }
        else if sex == "0"
        {
            figure = womenFigure[womenFigureView.tag-1100]
        }
        // 获取最小年龄
        var ageMin = ageMinChooseView.value=="最小值" ? "0" : ageMinChooseView.value
        // 获取最大年龄
        var ageMax = ageMaxChooseView.value=="最大值" ? "100" : ageMaxChooseView.value
        
        result["pro"] = proName
        result["city"] = city
        result["county"] = county
        result["userid"] = UserInfo.userID
//        result["pro"] = ""
//        result["city"] = ""
//        result["county"] = ""
        result["sex"] = sex
        result["figure"] = figure
        result["agemin"] = ageMin
        result["agemax"] = ageMax
        result["pageIndex"] = page
        return result
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toLoginAndRegistView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSBundle.mainBundle().loadNibNamed("NearPersonsViewController", owner: self, options: nil)[0];
        
        //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toLoginAndRegistView", name: "toLoginAndRegistView0", object: nil)
        var rightBar = UIBarButtonItem(title: "筛选", style: UIBarButtonItemStyle.Plain, target: self, action: "searchAction")
        rightBar.tintColor = UIColor.whiteColor()
        self.navigationItem.setRightBarButtonItem(rightBar, animated: true)

        UserInfo.refresh()
        
        setStyle()
        
        setDelegate()
        
        initializeLocationService()
    }
    /**
    初始化定位
    */
    func initializeLocationService() {
    geoCodeSearch = BMKGeoCodeSearch()
    geoCodeSearch.delegate = self
    // 初始化定位管理器
    locationManager = CLLocationManager()
    // 设置代理
    locationManager.delegate = self;
    // 设置定位精确度到米
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置定位权限 仅ios8有意义
//    if 
    if IOS8
    {
        locationManager.requestAlwaysAuthorization()
    //设置定位权限 仅ios8有意义
        locationManager.requestWhenInUseAuthorization()
    }
    // 开始定位
    locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        var loc=newLocation.coordinate
        
        var option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption()
        option.reverseGeoPoint=loc
        geoCodeSearch.reverseGeoCode(option)
        manager.stopUpdatingLocation()
    }
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if result != nil{
            var proName=(result.addressDetail.province==nil) ? "" : result.addressDetail.province
            var city=(result.addressDetail.city==nil) ? "" : result.addressDetail.city
            var region=(result.addressDetail.district==nil) ? "": result.addressDetail.district
            var location=(result.address==nil) ? "" : result.address
            var dict = ["proName":proName,"city":city,"region":region,"address":location]
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: nowLocation)            
        }
    }
    func searchAction()
    {
        if self.navigationItem.rightBarButtonItem?.title == "筛选"
        {
            var rightBar = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: "searchAction")
            rightBar.tintColor = UIColor.whiteColor()
            self.navigationItem.setRightBarButtonItem(rightBar, animated: true)
            var leftBar = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelAction")
            rightBar.tintColor = UIColor.whiteColor()
            self.navigationItem.setLeftBarButtonItem(leftBar, animated: true)
            
            
            if self.searchView.hidden
            {
                self.searchView.hidden = false
                self.searchView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
            }
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.searchView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            })
        }
        else
        {
            hidenSearchView()
            tableView.header.beginRefreshing()
        }
    }
    func cancelAction()
    {
       hidenSearchView()
    }
    func hidenSearchView()
    {
        self.ageMinChooseView.cancelButtonClicked()
        self.ageMaxChooseView.cancelButtonClicked()
        adressChooseViewGroup.cancelButtonClicked()
        self.searchView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        self.searchView.hidden = true
        var rightBar = UIBarButtonItem(title: "筛选", style: UIBarButtonItemStyle.Plain, target: self, action: "searchAction")
        rightBar.tintColor = UIColor.whiteColor()
        self.navigationItem.setRightBarButtonItem(rightBar, animated: true)
        
        self.navigationItem.leftBarButtonItem = nil
    }
    func setDelegate()
    {
        ageMinChooseView.datasource = self
        ageMaxChooseView.datasource = self
        adressChooseViewGroup.delegate = self
        var locationDict: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(lastLocation)
        if (locationDict != nil)
        {
            var dict = locationDict as! [String:String]
            adressChooseViewGroup.selectedProName = dict["proName"]
            adressChooseViewGroup.selectedCity = dict["city"]
            adressChooseViewGroup.selectedRegion = dict["region"]
        }
        
        tableView.registerNib(UINib(nibName: "PerSonTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "downLoad")
        tableView.header.autoChangeAlpha = true
        
        tableView.footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "upLoad")
        tableView.footer.autoChangeAlpha = true
        
        tableView.header.beginRefreshing()
        
    }
    func downLoad()
    {
        if UserInfo.isLogin
        {
            reloadData()
        }
        else
        {
            self.tableView.header.endRefreshing()
            self.tableView.footer.endRefreshing()
        }
    }
    func upLoad()
    {
        reloadData(page: dataArray.count)
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
    func chooseViewSureButtonClicked(chooseView: ChooseView!) {
        
    }
    func chooseView(chooseView: ChooseView!, numberOfRowsInComponent componen: Int) -> Int {
        if chooseView == ageMinChooseView
        {
            return 100
        }
        else
        {
            if (ageMinChooseView.value.toInt() != nil)
            {
                return 100-ageMinChooseView.value.toInt()!
            }
            else
            {
                return 100
            }
        }
    }
    func numberOfComponentsInChooseView(chooseView: ChooseView!) -> Int {
        return 1
    }
    func chooseView(chooseView: ChooseView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if chooseView == ageMinChooseView
        {
            return toString(row)
        }
        else
        {
            if (ageMinChooseView.value.toInt() != nil)
            {
                return toString(ageMinChooseView.value.toInt()!+row+1)
            }
            else
            {
                return toString(row+1)
            }
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func setStyle()
    {
        var viewFoot = UIView()
        viewFoot.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = viewFoot
        
        sexWidthConstraint.constant = (screenWidth - 32) / 3
        
        ageMinChooseView.layer.masksToBounds = true
        ageMinChooseView.layer.cornerRadius = 0
        ageMinChooseView.layer.borderColor = UIColor.lightGrayColor().CGColor
        ageMinChooseView.layer.borderWidth = 0.5
        
        ageMaxChooseView.layer.masksToBounds = true
        ageMaxChooseView.layer.cornerRadius = 0
        ageMaxChooseView.layer.borderColor = UIColor.lightGrayColor().CGColor
        ageMaxChooseView.layer.borderWidth = 0.5
        
        allFigureView.layer.borderColor = UIColor.lightGrayColor().CGColor
        allFigureView.layer.borderWidth = 0.5
        
        for buttonItem in sexView.subviews
        {
            if buttonItem is UIButton
            {
                var button = buttonItem as! UIButton
                button.layer.borderColor = UIColor.lightGrayColor().CGColor
                button.layer.borderWidth = 0.5
                button.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        for buttonItem in manFigureView.subviews
        {
            if buttonItem is UIButton
            {
                var button = buttonItem as! UIButton
                button.layer.borderColor = UIColor.lightGrayColor().CGColor
                button.layer.borderWidth = 0.5
                button.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }

        for buttonItem in womenFigureView.subviews
        {
            if buttonItem is UIButton
            {
                var button = buttonItem as! UIButton
                button.layer.borderColor = UIColor.lightGrayColor().CGColor
                button.layer.borderWidth = 0.5
                button.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }

    }
    func btnAction(button:UIButton)
    {
        for buttonItem in button.superview!.subviews
        {
            if buttonItem is UIButton
            {
                (buttonItem as! UIButton).setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                (buttonItem as! UIButton).backgroundColor = UIColor.whiteColor()
            }
        }
        button.superview?.tag = button.tag
        button.setTitleColor(UIColor(rgbByFFFFFF: 0x0079FD), forState: UIControlState.Normal)
        button.backgroundColor = UIColor(rgbByFFFFFF: 0xF0F0F0)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PerSonTableViewCell
        cell.setData(dataArray[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc = EditInformationViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.userId = dataArray[indexPath.row]["userid"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 93
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    @IBAction func allSexAction(sender: AnyObject) {
//        allFigureView.hidden = false
//        manFigureView.hidden = true
//        womenFigureView.hidden = true
        mainFigureView.hidden = true
        ageLabelTopConstraint.constant = 8
    }
    
    @IBAction func mansexAction(sender: AnyObject) {
        mainFigureView.hidden = false
        allFigureView.hidden = true
        manFigureView.hidden = false
        womenFigureView.hidden = true
        ageLabelTopConstraint.constant = 69
    }
    
    @IBAction func womenSexAction(sender: AnyObject) {
        mainFigureView.hidden = false
        allFigureView.hidden = true
        manFigureView.hidden = true
        womenFigureView.hidden = false
        ageLabelTopConstraint.constant = 69
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
