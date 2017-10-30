//
//  ProductDetailControllerViewController.swift
//  Trendify
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class ProductDetailControllerViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CellSizeDelegate
{
    
    @IBOutlet weak var TblVW: UITableView!
    
    var product : ProductListNewResponseModel!
    var productDetails : ProductDetailsResponseModel!
    var pageType:String!
    var itemName:String!
    
    var selectedSize : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TblVW.estimatedRowHeight = 50;
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        Utility.showProgressHud(text: "")
        ProductDetailsResponseModel.GetProductDetails(pageType: pageType, itemName: itemName, locationId: "", itemID: String( describing: (product?.itemId)!)) { (data, error) in
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                
                if(data != nil){
                    self.productDetails = data!
                    
                    self.TblVW.reloadData();
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        }
        
    }
    
    @IBAction func BuyNowClicked(_ sender: Any) {
    }
    
    @IBAction func AddCartClicked(_ sender: Any) {
        var VC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController")
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(productDetails != nil){
            return  4;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0 ){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductImageTVCell") as! ProductImageTVCell
            cell.configureCell(image: productDetails.ProductDetails[0].image1!)
            return cell;
        }else if(indexPath.row == 1 ){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTVCell") as! ProductNameTVCell
            cell.LblProductName.text = productDetails.ProductDetails[0].productName
            cell.LblMrpPrice.attributedText = Utility.GetStrikeThroughTxt(str: "Rs." + String(productDetails.ProductDetails[0].mRP!))
            cell.LblSellingPrice.text = "Rs." + String(describing: productDetails.ProductDetails[0].sellingPrice!)
            return cell;
            
        }
        else if(indexPath.row == 2 ){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSizeTVCell") as! ProductSizeTVCell
            cell.delegate = self
            if(selectedSize == nil){
                cell.LblSize.text = "Select Size"
                cell.categoryItems = productDetails.ProductDetails
                cell.CollectionVW.reloadData()
            }else{
                cell.LblSize.text = "Size : " + productDetails.ProductDetails[selectedSize].size!
            }
            
            return cell;
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductQtyTVCell") as! ProductQtyTVCell
            if(selectedSize == nil){
                cell.LblOrderedQty.text = "Ordered Quantity : 0"
                cell.LblAvailableQty.text = ""
                cell.LblColor.text = ""
                cell.LblShippingCharge.text = ""
            }else{
                cell.LblOrderedQty.text = "Ordered Quantity : 0"
                cell.LblAvailableQty.text = "Available Quantity : " + String(describing: productDetails.ProductDetails[selectedSize].avaliableQty!)
                cell.LblColor.text = "Color : " + productDetails.ProductDetails[selectedSize].color!
                //                cell.LblShippingCharge.text = "" + productDetails.ProductDetails[selectedSize].
                
            }
            return cell;
        }
    }
    
    func SizeSelected(selected:Int){
        selectedSize = selected
        TblVW.reloadData()
    }
    
    
}
