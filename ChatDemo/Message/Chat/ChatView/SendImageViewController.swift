//
//  SendImageViewController.swift
//  ChatDemo
//
//  Created by user on 15/9/22.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit
protocol SendImageDelegate:NSObjectProtocol
{
    func sendImage(image:UIImage)
}
class SendImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var browseBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    var image:UIImage!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttomView: UIView!
    
    var delegate:SendImageDelegate!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSBundle.mainBundle().loadNibNamed("SendImageViewController", owner: self, options: nil)[0]
        imageView.image = self.image
        self.title = "发送图片"
        sendBtn.layer.cornerRadius = 5
        sendBtn.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        var tap = UITapGestureRecognizer(target: self, action: "hidenAction")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tap)
    }
    func setImageItem(img:UIImage)
    {
        self.image = img
        if (imageView != nil)
        {
            imageView.image = self.image
        }
    }
    func hidenAction()
    {
        var bo = !buttomView.hidden
        topView.hidden = bo
        buttomView.hidden = bo
    }
    @IBAction func browseAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func sendImage(sender: AnyObject) {
        delegate.sendImage(self.image)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
