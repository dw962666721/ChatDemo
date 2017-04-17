//
//  ShowNumberViewController.swift
//  ChatDemo
//
//  Created by user on 15/10/8.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class ShowNumberViewController: UIViewController {

    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var numberTextFiled: UILabel!
    var number:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册成功"
        NSBundle.mainBundle().loadNibNamed("ShowNumberViewController", owner: self, options: nil)[0]
        enterBtn.layer.masksToBounds = true
        enterBtn.layer.cornerRadius = 5
        numberTextFiled.text = number
        // Do any additional setup after loading the view.
        var backBtn:UIButton! = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        backBtn.frame = CGRectMake(10, 20, 12, 18)
//        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
//        backBtn.setBackgroundImage(UIImage(named: "返回"), forState: UIControlState.Normal)
//        backBtn.setBackgroundImage(UIImage(named: "返回点击"), forState: UIControlState.Highlighted)
        var leftBarButton:UIBarButtonItem! = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    @IBAction func enterAction(sender: AnyObject) {
         self.navigationController?.popToRootViewControllerAnimated(true)
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
