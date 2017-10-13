//
//  ProductQtyTVCell.swift
//  Trendify
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class ProductQtyTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var LblColor: UILabel!
    @IBOutlet weak var LblAvailableQty: UILabel!
    @IBOutlet weak var LblShippingCharge: UILabel!
    @IBOutlet weak var LblOrderedQty: UILabel!
}
