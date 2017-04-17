//
//  IdentifyView.swift
//  三个image
//
//  Created by admin on 15-4-2.
//  Copyright (c) 2015年 YODO. All rights reserved.
//

import UIKit

class IdentifyView: UIView {
    var identify:Int=0{
        didSet{
            var count=0
            for var i = 2;i > -1;i--
            {
                var identifyImgView = imageViews[i]
                identifyImgView.hidden = (identify&(1<<i)==0)
                if !identifyImgView.hidden{
                    identifyImgView.frame=CGRect(x: 26*count, y: 0, width: i==0 ? 19 : 24, height: 14)
                    count++

                }
            }
        }
    }
    private var imageViews:[UIImageView]=[]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initWithIdentifyImageView()
        
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithIdentifyImageView()
    }
    
    private func initWithIdentifyImageView()
    {
        for var i = 0;i<3;i++
        {
            var identifyImgView = UIImageView()
            imageViews.append(identifyImgView)
            identifyImgView.image = UIImage(named: "identify\(1<<i)")
            self.addSubview(identifyImgView)
        }

    }
    

}
