//
//  CartTVCell.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 16/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class CartTVCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var LblProductName: UILabel!
    @IBOutlet weak var LblMrpPrice: UILabel!
    @IBOutlet weak var LblSellingPrice: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
