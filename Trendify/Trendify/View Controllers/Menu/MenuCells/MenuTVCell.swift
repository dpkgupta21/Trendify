//
//  MenuTVCell.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 21/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class MenuTVCell: UITableViewCell {
    
    @IBOutlet weak var BtnHeader: UIButton!
    @IBOutlet weak var BtnDropDown: UIButton!
    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var ImgLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func congfigureCell( item: CategoryItem) {
        LblTitle.text = item.category;
        let font = UIFont.systemFont(ofSize: 17);
        LblTitle.font = font;
        ImgLogo.image = UIImage(named: item.categoryImageName!)
        BtnHeader.isEnabled = true;
        self.backgroundColor = UIColor.white;
        BtnDropDown.isHidden = false
        BtnDropDown.isSelected = item.isExpanded
    }
    
    func Configure( title:String,isbold:Bool) {
        let font = UIFont.systemFont(ofSize: 14);
        LblTitle.font = font;
        LblTitle.text = title;
        ImgLogo.image = nil;
        BtnHeader.isEnabled = false
        BtnDropDown.isHidden = true
    }
    @IBAction func BtnHeaderClicked(_ sender: Any) {
        
    }
    
}
