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
    var product:ProductDetailsModel!
    var index:Int=0
    
    @IBOutlet weak var LblProductName: UILabel!
    @IBOutlet weak var LblMrpPrice: UILabel!
    @IBOutlet weak var LblSellingPrice: UILabel!
    @IBOutlet weak var ImgProductIcon: UIImageView!
    @IBOutlet weak var LblSelectedSize: UILabel!
    @IBOutlet weak var LblStock: UILabel!
    @IBOutlet weak var LblOrderQyt: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
      @IBOutlet weak var btnMinus: UIButton!
      @IBOutlet weak var btnPlus: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func SetImage(image : String){
        let img = image.components(separatedBy: ",")[0]
        
        ImgProductIcon.sd_setImage(with: URL(string: "http://trendyfy.com" + (img.replacingOccurrences(of: "~", with: ""))), placeholderImage: UIImage(named: "placeholder"))
    }
    
//    @IBAction func btnActionDecrease(_ sender: Any) {
//        if((product.orderQty)>0 && (product.orderQty < product.avaliableQty!)){
//            product.orderQty = product.orderQty+1
//            CategoryItem.cartItemsArray[index] = product
//        }
//        
//    }
//    
//    @IBAction func BtnActionIncrease(_ sender: Any) {
//        
//        if((product.orderQty) < product.avaliableQty!){
//            product.orderQty = product.orderQty+1
//            CategoryItem.cartItemsArray[index] = product
//        }
//    }
   
    
    
}
