//
//  ProductSizeTVCell.swift
//  Trendify
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

protocol CellSizeDelegate {
    func SizeSelected(selected:Int);
}

class ProductSizeTVCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

     var categoryItems:[ProductDetailsModel] = [ProductDetailsModel]()
    var delegate:CellSizeDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var LblSize: UILabel!
    @IBOutlet weak var CollectionVW: UICollectionView!

    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categoryItems.count;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCVCell", for: indexPath) as! SizeCVCell
        cell.LblTitle.text = categoryItems[indexPath.row].size!
        cell.LblTitle.borderColor = UIColor.black
        cell.LblTitle.cornerRadius = Int(collectionView.frame.height / 2 - 10)
        cell.LblTitle.borderWidth = 1
        cell.LblTitle.masksToBounds = false
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(delegate != nil ){
        delegate.SizeSelected(selected: indexPath.row)
        }
    }
    
}
