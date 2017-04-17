//
//  BaseNavagationMemberViewController.swift
//  E_Education
//
//  Created by admin on 14-8-28.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//




class BaseNavagationMemberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //  返回按钮
        var backBtn:UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        backBtn.frame = CGRectMake(10, 20, 12, 18)
        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        backBtn.setBackgroundImage(UIImage(named: "返回"), forState: UIControlState.Normal)
        backBtn.setBackgroundImage(UIImage(named: "返回点击"), forState: UIControlState.Highlighted)
        var leftBarButton:UIBarButtonItem! = UIBarButtonItem(customView: backBtn)
//        self.navigationItem.backBarButtonItem = leftBarButton

        var button=self.navigationItem.rightBarButtonItem?.customView
        if button != nil {
//        button?.layer.shadowColor=UIColor.lightGrayColor().CGColor
//        button?.layer.shadowOffset=CGSize(width: -10, height: 0)
//        button?.layer.shadowOpacity=1
//        button?.layer.shadowRadius=10
//        button?.backgroundColor=UIColor(patternImage: UIImage(named: "导航栏")!)
//        var negativeSeperator:UIBarButtonItem=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
//        negativeSeperator.width=CGFloat(-14)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.barButtonItemWithWidth(-14),UIBarButtonItem(customView: button!)], animated: false)
        }
//        self.navigationController.interactivePopGestureRecognizer.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    // 返回按钮
    func backBtnClick()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
