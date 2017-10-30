//
//  ProductImageTVCell.swift
//  Trendify
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import SDWebImage

class ProductImageTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var ImgProductIcon: UIImageView!

    func configureCell(image : String){
        let img = image.components(separatedBy: ",")[0]
        
        ImgProductIcon.sd_setImage(with: URL(string: "http://trendyfy.com" + (img.replacingOccurrences(of: "~", with: ""))), placeholderImage: UIImage(named: "placeholder"))
    }
    
    
}
