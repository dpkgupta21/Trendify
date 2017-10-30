//
//  ProductListViewController.swift
//  Trendify
//
//  Created by APPLE on 12/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import SDWebImage

class ProductListViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var MenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var CollectionVW: UICollectionView!
    var categoryItems:[ProductListNewResponseModel] = [ProductListNewResponseModel]()
    var selectedCategoryItem:ProductListNewResponseModel!
    
    var pageType:String!
    var itemName:String!
    var locationID:String!
    var groceryCategoryId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.revealViewController().rearViewRevealOverdraw=0;
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-50;
        GetItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! ProductDetailControllerViewController
        VC.product = selectedCategoryItem
        VC.pageType = self.pageType
        VC.itemName = self.itemName
    }
    
    func GetItems(){
        Utility.showProgressHud(text: "")
        ProductListNewResponseModel.GetProductItems(pageType: pageType, itemName: itemName,locationId: locationID,groceryCategoryId: groceryCategoryId) { (data, error) in
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                
                if(data != nil){
                    self.categoryItems = data!
                    
                    self.CollectionVW.reloadData();
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categoryItems.count;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVCell", for: indexPath) as! ProductCVCell
        
        cell.ProductImageIcon.sd_setImage(with: URL(string: "http://trendyfy.com" + (categoryItems[indexPath.row].image1?.replacingOccurrences(of: "~", with: ""))!), placeholderImage: UIImage(named: "placeholder"))
        cell.LblProductName.text = categoryItems[indexPath.row].productName;
        cell.LblMrpPrice.attributedText = Utility.GetStrikeThroughTxt(str: "Rs. "+String(describing: categoryItems[indexPath.row].mRP!));
        cell.LblSellingPrice.text = "Rs. "+String(describing: categoryItems[indexPath.row].sellingPrice!);
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var width = collectionView.frame.width / 2  - 10;
        var size = CGSize(width: width, height: width * 1.5)
        return size
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryItem = categoryItems[indexPath.row]
        self.performSegue(withIdentifier: "ProductDetailsSegue", sender: self)
    }
    
    
    @IBAction func MenuClicked(_ sender: Any) {
        
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self);
            
        }
        
    }
    
}
