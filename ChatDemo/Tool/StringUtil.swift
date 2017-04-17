//
//  StringCastUtil.swift
//  E_Education
//
//  Created by admin on 14-8-27.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//

import UIKit

extension String {
    var floatValue:Float{
        get{
            return   NSString(string: self).floatValue
        }
    }
    /**
    移除字符串最后的空白符（不包含换行符）
    */
    func Trim()->String!
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    /**
    移除字符串最后的空白符（包含换行符）
    */
    func TrimAndLine()->String!
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    func boundingRectWithSize(font:UIFont,constrainedToSize:CGSize=CGSize(width:CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))->CGSize{
        var temp:NSString=self
        return temp.boundingRectWithSize(constrainedToSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
    }
    
    func boundingRectWithSizeandparagraph(font:UIFont,constrainedToSize:CGSize=CGSize(width:CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))->CGSize{
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        var temp:NSString=self
        return temp.boundingRectWithSize(constrainedToSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle], context: nil).size
    }
    
    struct _Dummy {
        var idxVal: Int
        var _padding: Int
        var _padding2: Int
        var _padding3: Int
        var _padding4: Int
    }
    subscript (i: Int) -> Character {
        var dummy: _Dummy =  unsafeBitCast(i >= 0 ? self.startIndex : self.endIndex, _Dummy.self)
            dummy.idxVal += i
            let idx: String.Index = unsafeBitCast(dummy, String.Index.self)
            return self[idx]
    }
    subscript (subRange: Range<Int>) -> String {
        
        var start: _Dummy = unsafeBitCast(self.startIndex,_Dummy.self)
            var end = start
            start.idxVal = subRange.startIndex
            end.idxVal = subRange.endIndex-1
            let startIndex: String.Index = unsafeBitCast(start, String.Index.self)
            let endIndex: String.Index = unsafeBitCast(end,String.Index.self)
            return self[startIndex...endIndex]
    }
    //
    //  StringToImage.swift
    //  ImageChangeColor
    //
    //  Created by admin on 14-10-22.
    //  Copyright (c) 2014年 TFQ. All rights reserved.
    //
    
    
    func getHollowOutImage(size:CGSize,backgroundcolor:UIColor,font:UIFont)->UIImage{
        let title=(self as NSString)
        //        rect.midX
        var dic:[String:AnyObject]=[NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.blackColor()];
        var titleSize=title.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT)
            , CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: dic, context: nil).size
        UIGraphicsBeginImageContext(size);
        var titleRect:CGRect=CGRect(origin: CGPoint(x: (size.width-titleSize.width)/2, y: (size.height-titleSize.height)/2), size: CGSize(width: titleSize.width, height: titleSize.height))
        
        
        
        title.drawInRect(titleRect, withAttributes: dic)
        
        var image=UIImage(CGImage: CGBitmapContextCreateImage(UIGraphicsGetCurrentContext()))
        // 1.
        var inputCGImage:CGImageRef = image!.CGImage
        var width:Int = Int(CGImageGetWidth(inputCGImage))
        var height:Int = Int(CGImageGetHeight(inputCGImage))
        // 2.
        var bytesPerPixel:Int=4
        var bytesPerRow:Int=bytesPerPixel * width
        var bitsPerComponent:Int=8
        
        var pixels=calloc(Int(height * width),sizeof(UInt32))
        
        // 3.
        var colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        
        var context :CGContextRef = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace,CGBitmapInfo(16385))
        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: Int(width), height: Int(height))), inputCGImage);
        
        var currentPixel = unsafeBitCast(pixels,UnsafeMutablePointer<UInt32>.self)
        func Mask8(color:UInt32)->UInt32 {
            return color & 0xFF
        }
        func R(color:UInt32)->UInt32{
            return Mask8(color)
        }
        func G(color:UInt32)->UInt32{
            return Mask8(R(color>>8))
        }
        func B(color:UInt32)->UInt32{
            return Mask8(R(color>>16))
        }
        func A(color:UInt32)->UInt32{
            return Mask8(R(color>>24))
        }
        func RGBAMake(r:UInt32,g:UInt32,b:UInt32,a:UInt32)->UInt32{
            return Mask8(r)|Mask8(g)<<8|Mask8(b)<<16|Mask8(a)<<24
        }
        var r:CGFloat=0
        var g:CGFloat=0
        var b:CGFloat=0
        var a:CGFloat=0
        var flag=backgroundcolor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        for  var j:Int = 0; j < height; j++  {
            for var i:Int = 0; i < width; i++  {
                // 3.
                var color:UInt32 = currentPixel.memory
                var a0:UInt32=255-A(color)
                if(A(color)==0){
                    currentPixel.initialize(RGBAMake(UInt32(b*255), UInt32(g*255), UInt32(r*255), 255))
                }else{
                    currentPixel.initialize(RGBAMake(UInt32(b*CGFloat(a0)), UInt32(g*CGFloat(a0)), UInt32(r*CGFloat(a0)), 255-A(color)))
                }
                // 4.
                currentPixel++
            }
        }
        image = UIImage(CGImage: CGBitmapContextCreateImage(context))
        return image!
        
    }
    
    
}

