//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by user on 15/7/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    var dataArray:[[String:AnyObject]]=[]
    var userData=["name":"未知","age":"18"]
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userData["name"]
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        // Do any additional setup after loading the view.
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
