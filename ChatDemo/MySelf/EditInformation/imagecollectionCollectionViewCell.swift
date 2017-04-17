//
//  imagecollectionCollectionViewCell.swift
//  CrazyWaste
//
//  Created by user on 15/7/28.
//  Copyright (c) 2015年 JohnSon. All rights reserved.
//

import UIKit

class imagecollectionCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }
    func setImage(image:UIImage)
    {
        self.img.image = image
    }
    func setImageStr(imageStr:String)
    {
        self.img.sd_setImageWithURL(NSURL(string: ServerURL + imageStr), placeholderImage: UIImage(named: "加载失败"))
    }
}
