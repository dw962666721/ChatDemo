//
//  HandleUploadPhotos.swift
//  E_Education
//
//  Created by admin on 14-8-12.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit
@objc protocol HandleUploadPhotosDelegate{
    func imagePickerControllerDidFinishPickingMediaWithInfo(image:UIImage)
    
    optional func imagePickerControllerDidCancel()
}

class HandleUploadPhotos: NSObject,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // 创建结构体用来存储实例变量
    private struct instance{
        static var instance:HandleUploadPhotos!=HandleUploadPhotos()
    }
    var delegate:HandleUploadPhotosDelegate!
    var aspect:Bool=true
    var allowsEditing:Bool=false
    // 调用此方法 实例变量只能创建一次
    private override init() {
        super.init()
    }
    var currentViewController:UIViewController!
    class func photoPicker(currentViewController vc:UIViewController,delegate:HandleUploadPhotosDelegate,allowsEditing:Bool=false,aspect:Bool=true){
        
        var actionSheet:UIActionSheet = UIActionSheet(title:nil, delegate: instance.instance, cancelButtonTitle: "取消", destructiveButtonTitle:nil , otherButtonTitles:"拍照", "图库")
        instance.instance.delegate=delegate
        instance.instance.aspect=aspect
        instance.instance.currentViewController=vc
        instance.instance.allowsEditing=allowsEditing
        var window = UIApplication.sharedApplication().keyWindow
//        instance.instance.currentViewController.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        actionSheet.showInView(window)
    }
    
    final func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        HandleUploadPhotos.presentImagePickerViewController(UIImagePickerControllerSourceType(rawValue: 2-buttonIndex),sourceViewController: self.currentViewController,delegate: self.delegate,allowsEditing:self.allowsEditing,aspect: self.aspect);
    }
    class func presentImagePickerViewController(sourceType:UIImagePickerControllerSourceType!,sourceViewController:UIViewController,delegate:HandleUploadPhotosDelegate,aspect:Bool=false,allowsEditing:Bool=true){
        var instance=HandleUploadPhotos.instance.instance
        var picker:UIImagePickerController = UIImagePickerController()
        picker.navigationBar.tintColor = UIColor.whiteColor()
        picker.navigationBar.titleTextAttributes = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName) as [NSObject : AnyObject]
        picker.navigationBar.barTintColor = UIColor.blackColor()
        picker.navigationItem
        picker.delegate = instance
        picker.navigationController?.delegate = instance
        instance.delegate=delegate
        instance.aspect=aspect
        //设置拍照后的图片可被编辑
        picker.allowsEditing = allowsEditing
        // 如果选择的是摄像头 则判断机器上是否有摄像头。
        if sourceType == UIImagePickerControllerSourceType.Camera && (!instance.hasRearCamera() && !instance.hasFrontCamera())
        {
            instance.showErr()
            return
        }
        picker.sourceType = sourceType
        if(sourceType == .SavedPhotosAlbum)
        {
            return
        }
        else
        {
            if  UIImagePickerController.availableMediaTypesForSourceType(sourceType) == nil
            {
                return
            }
        }
        
        sourceViewController.presentViewController(picker, animated: true, completion: nil)
    }
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if navigationController.isKindOfClass(UIImagePickerController) && (navigationController as! UIImagePickerController).sourceType == UIImagePickerControllerSourceType.PhotoLibrary
        {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        }
    }
    func showErr()
    {
        var dialog=TFQAlertUtil()
        dialog.text = "额˜˜,木有发现摄像头设备"
        dialog.showAlert()
    }
    
    func hasRearCamera() -> Bool
    {
        return   UIImagePickerController.isCameraDeviceAvailable( UIImagePickerControllerCameraDevice.Rear)
    }
    func hasFrontCamera() -> Bool
    {
        return   UIImagePickerController.isCameraDeviceAvailable( UIImagePickerControllerCameraDevice.Front)
    }

    // 图像选取完成后的回调方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        popToPicker(picker)
        
        var image:UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        image = self.imageWithImageSimple(image, newSize: CGSizeMake(200, 200))
        self.delegate.imagePickerControllerDidFinishPickingMediaWithInfo(image)
    }
    
    private func popToPicker(picker: UIImagePickerController!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    final func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        popToPicker(picker)
        self.delegate.imagePickerControllerDidCancel?()
    }
    //压缩图片
    func imageWithImageSimple(image:UIImage,var newSize:CGSize )->UIImage
    {
        // Create a graphics image context,Tell the old image to draw in this new context, with the desired
        // 启动自适应 如果当前图片尺寸太大 则等比例缩小
      
        if aspect
        {
            if image.size.width > UIScreen.mainScreen().bounds.width
            {
                var ratio:CGFloat=image.size.width/image.size.height
                newSize.width = UIScreen.mainScreen().bounds.width
                newSize.height = newSize.width/ratio
            }
            else
            {
                newSize = image.size
            }
        }
        UIGraphicsBeginImageContext(newSize)
        // new size
        image.drawInRect(CGRect(origin:CGPointZero,size:newSize))
        // Get the new image from the context
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // End the context
        UIGraphicsEndImageContext()
        // Return the new image.
        return newImage
    }

    
}
