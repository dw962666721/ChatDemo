//
//  SafecenterViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class SafecenterViewController: UIViewController {

    @IBOutlet weak var bindLabel: UILabel!
    @IBOutlet weak var safeLevelLabel: UILabel!
    @IBOutlet weak var safeImageView: UIImageView!
    @IBOutlet weak var pswView: UIView!
    @IBOutlet weak var qView: UIView!
    @IBOutlet weak var phoneView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全中心"
        NSBundle.mainBundle().loadNibNamed("SafecenterViewController", owner: self, options: nil)[0]
        if UserInfo.Tel == ""
        {
            bindLabel.text = "绑定"
            safeLevelLabel.text = "安全等级：低"
            safeImageView.image = UIImage(named: "unSafe")
        }
        else
        {
            bindLabel.text = "修改"
            safeLevelLabel.text = "安全等级：高"
            safeImageView.image = UIImage(named: "safe")
        }
        qView.layer.borderColor = UIColor(rgbByFFFFFF: 0xf0f0f0).CGColor
        qView.layer.borderWidth = 1
        
        var tap0 = UITapGestureRecognizer(target: self, action: "editPsw")
        tap0.numberOfTapsRequired = 1
        tap0.numberOfTouchesRequired=1
        pswView.addGestureRecognizer(tap0)
        
        var tap1 = UITapGestureRecognizer(target: self, action: "editQQ")
        tap1.numberOfTapsRequired = 1
        tap1.numberOfTouchesRequired=1
        qView.addGestureRecognizer(tap1)
        
        var tap2 = UITapGestureRecognizer(target: self, action: "editPhone")
        tap2.numberOfTapsRequired = 1
        tap2.numberOfTouchesRequired=1
        phoneView.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }
    func editPsw()
    {
        var editPswVC = EditPswViewController()
        self.navigationController?.pushViewController(editPswVC, animated: true)
    }
    func editQQ()
    {
        var vc = EditQQAndTelViewController()
        vc.type = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func editPhone()
    {
        var vc = EditQQAndTelViewController()
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
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
