//
//  StarRankView.swift
//  DeshellEducation
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 TFQ. All rights reserved.
//




class StarRankView: UIView {
    var rank: Int!=4{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var starImage:UIImage!=UIImage(named: "star_s"){
        didSet{
            self.setNeedsDisplay()
        }
    }
     override init(frame: CGRect) {
        
        super.init(frame: frame)
        // Initialization code here.
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func drawRect(dirtyRect: CGRect) {
        super.drawRect(dirtyRect)

        var context :CGContext = UIGraphicsGetCurrentContext()

        var   normalState: CGAffineTransform=CGContextGetCTM(context);
        CGContextTranslateCTM(context, 0, dirtyRect.height)
        CGContextScaleCTM(context, 1, -1)
        if rank != nil {
            for i in 0..<5
            {
                
                CGContextDrawImage(context, CGRectMake(CGFloat(10*i), (dirtyRect.height-9)/2, 9, 9)
                    , (i<rank ? starImage : UIImage(named: "star_grey")).CGImage)
                
            }
        }
        
        CGContextConcatCTM(context, normalState);
        


        // Drawing code here.
    }
    
}
