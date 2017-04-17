//
//  TextFieldListener.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

class TextFieldListener:NSObject{
    lazy private var recognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("inputDidEnd"))
    //       var bottomView:UIView!
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChange:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    weak var currentTextField:UIView!{
        didSet{
            if oldValue==nil {
                UIApplication.sharedApplication().keyWindow!.removeGestureRecognizer(recognizer)
            }
        }
    }
    class func shareInstance()->TextFieldListener{
        struct Singleton {
            
            static var singleton:TextFieldListener! = TextFieldListener()
        }
        
        return Singleton.singleton
    }
    func keyboardWillHide(notification:NSNotification){
        UIApplication.sharedApplication().keyWindow!.removeGestureRecognizer(recognizer)
        currentTextField=nil
        
    }
    
    func inputDidEnd(){
        
        self.currentTextField.resignFirstResponder()
    }
    func keyboardWillChange(notification:NSNotification)
    {
        if self.currentTextField == nil{
            return
        }
        recognizer.cancelsTouchesInView=false
        UIApplication.sharedApplication().keyWindow!.addGestureRecognizer(recognizer)
        var bottomView=self.currentTextField as UIView
        var y:CGFloat=bottomView.frame.height
        while(bottomView.frame.height != UIScreen.mainScreen().bounds.height){
            y+=bottomView.frame.origin.y
            if bottomView is UIScrollView
            {
                y -=  (bottomView as! UIScrollView).contentOffset.y
            }
            if let superView=bottomView.superview{
                bottomView=superView

            }else{
                return
            }
            //println("y========\(y)")
            
        }
        if self.currentTextField != nil{
            //        开始动画
            let duration:Double=(notification.userInfo! as NSDictionary)["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
            
            var end:CGFloat = (notification.userInfo! as NSDictionary)[UIKeyboardFrameEndUserInfoKey]!.CGRectValue().origin.y
            
            var contentOffset:CGPoint=CGPointZero
            if bottomView is UIScrollView
            {
                contentOffset =  (bottomView as! UIScrollView).contentOffset
            }
            var cell:UIView = self.currentTextField.superview!
            var changeHeight:CGFloat = y - end
            UIView.animateWithDuration(duration, animations: {
                
                if end == UIScreen.mainScreen().bounds.height
                {
                    bottomView.transform = CGAffineTransformIdentity
                }
                else if changeHeight>0
                {
                    var keyboardHeight=UIScreen.mainScreen().bounds.height-end
                    changeHeight = changeHeight<keyboardHeight ? changeHeight : keyboardHeight
                    bottomView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -changeHeight)
                //println("keyboardHeight====\(keyboardHeight)")
                }
               //println("changeHeight====\(changeHeight)")
            })
        }
    }
    
}