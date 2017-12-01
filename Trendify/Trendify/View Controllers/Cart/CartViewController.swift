//
//  CartViewController.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 16/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class CartViewController: ParentViewController, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var TblVW: UITableView!
    @IBOutlet weak var VIEWSHIPPING: UIView!
    @IBOutlet weak var VIEWBUTTONS: UIView!
    @IBOutlet weak var lblShippingCharge: UILabel!
    @IBOutlet weak var LblTotal: UILabel!
    var totel1:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TblVW.estimatedRowHeight = 50;
        // Do any additional setup after loading the view.
        UpdateCharges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       if CategoryItem.cartItemsArray.count==0
       {
        TblVW.isHidden=true
        VIEWSHIPPING.isHidden=true
        VIEWBUTTONS.isHidden=true
        }
        else
       {
        TblVW.isHidden=false
        VIEWSHIPPING.isHidden=false
        VIEWBUTTONS.isHidden=false
        }
        
    }

    @IBAction func ShopNow(_ sender: Any) {
        
        AppNavigation.ChangeToHomeVC(oldVC: self)
//        self.revealViewController().revealToggle(self);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CategoryItem.cartItemsArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVCell") as! CartTVCell
        let product:ProductDetailsModel=CategoryItem.cartItemsArray[indexPath.row]
        cell.product = product
        cell.index = indexPath.row
        cell.SetImage(image: product.image1!)
        cell.LblProductName.text = product.productName
       
        cell.LblMrpPrice.attributedText = Utility.GetStrikeThroughTxt(str: "Rs." + String(product.mRP!))
        cell.LblSellingPrice.text = "Rs." + String(describing: product.sellingPrice!)
        cell.LblSelectedSize.text = "Size : " + product.size!
        cell.LblStock.text = "Available Quantity : " + String(describing: product.avaliableQty!)
        cell.LblOrderQyt.text = String(product.orderQty)
        
        cell.btnRemove.layer.setValue(NSNumber(value: indexPath.row), forKey: "row")
        cell.btnRemove.addTarget(self, action: #selector(DeleteRow), for: UIControlEvents.touchUpInside)
        
        cell.btnMinus.layer.setValue(NSNumber(value: indexPath.row), forKey: "row")
        cell.btnMinus.addTarget(self, action: #selector(MinusRow), for: UIControlEvents.touchUpInside)
        
        cell.btnPlus.layer.setValue(NSNumber(value: indexPath.row), forKey: "row")
        cell.btnPlus.addTarget(self, action: #selector(PlusRow), for: UIControlEvents.touchUpInside)
        
        
        return cell;
    }
    
    func DeleteRow(btn:UIButton) {
        let Index:Int = btn.layer.value(forKey: "row") as! Int
        if CategoryItem.cartItemsArray.count>Index {
            CategoryItem.cartItemsArray.remove(at: Index)
        }
        self.TblVW.reloadData()
        UpdateCharges()
    }
    
    func MinusRow(btn:UIButton) {
        let Index:Int = btn.layer.value(forKey: "row") as! Int
        if CategoryItem.cartItemsArray.count>Index {
            let product:ProductDetailsModel = CategoryItem.cartItemsArray[Index]
            
            if((product.orderQty)>0 && (product.orderQty <= product.avaliableQty!)){
                product.orderQty = product.orderQty-1
                CategoryItem.cartItemsArray[Index] = product
            }
        }
        self.TblVW.reloadData()
        UpdateCharges()
    }
    
    func PlusRow(btn:UIButton) {
        let Index:Int = btn.layer.value(forKey: "row") as! Int
        if CategoryItem.cartItemsArray.count>Index {
            let product:ProductDetailsModel = CategoryItem.cartItemsArray[Index]
            
            if((product.orderQty)>0 && (product.orderQty < product.avaliableQty!)){
                product.orderQty = product.orderQty+1
                CategoryItem.cartItemsArray[Index] = product
            }
        }
        self.TblVW.reloadData()
        UpdateCharges()
    }
    
    
    func UpdateCharges() {
        var totel:Int = 0
        var ShippingTotal:Int = 0
        let shipping:Int=60;
        
        for product in CategoryItem.cartItemsArray {
            totel+=(product.orderQty*product.sellingPrice!)
            ShippingTotal += (product.orderQty*shipping);
        }
        totel += ShippingTotal;
        LblTotal.text = "Rs. " + String(totel)
        lblShippingCharge.text="Rs. " + String(ShippingTotal)
        totel1 = totel
    }
    
    @IBAction func BuyNowClicked(_ sender: Any) {
        if(UserDeafultsManager.SharedDefaults.IsLoggedIn==true)
        {
         
            DeliverySummeryView()
        }
        else
        {
            LoginView()
        }
    }
    
    func LoginView()
    {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.navigationController?.pushViewController(VC!, animated: true)
      
    }
    func DeliverySummeryView()
    {
        let VC: DeliverySummaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeliverySummaryViewController") as! DeliverySummaryViewController
        VC.cartAmount = Float(totel1)
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
}
