//
//  DeliverySummaryViewController.swift
//  Trendify
//
//  Created by Ghanshyam Jain on 14/11/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class DeliverySummaryViewController: UIViewController {
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblCashbackAmount: UILabel!
    @IBOutlet var lblPayableAmount: UILabel!
    @IBOutlet var lblDeliveryAddress: UILabel!
    var cartAmount:Float!
    var cashbackAmount:Float!=0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title="Delivery Summary"
        // Do any additional setup after loading the view.
        updateAmount()
        DeleteItemFromCart(userID: UserDeafultsManager.SharedDefaults.MemberID)
        
        CustomerCashback(username: UserDeafultsManager.SharedDefaults.Username)
        
    }
    
    func updateAmount(){
        lblAmount.text = "Rs. " + String(cartAmount);
        lblPayableAmount.text = "Rs. " + String(cartAmount+cashbackAmount)
        lblCashbackAmount.text = "Rs. " + String(cashbackAmount)
        lblDeliveryAddress.text = UserDeafultsManager.SharedDefaults.AddressWithCity
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnActionCashOnDelivery(_ sender: Any) {
        
        let str :String = UserDeafultsManager.SharedDefaults.LoginData
        
        let jsonObj:JSON = str.toJSON() as! JSON

        let login = LoginResponseModel(json: jsonObj)
        
        CashOnDelivery(LoginData: login!, cashback: Int(cashbackAmount))
        
    }
    
    @IBAction func btnActionOnlinePayment(_ sender: Any) {
        
        Utility.showProgressHud(text: "");
        
        let str :String = UserDeafultsManager.SharedDefaults.LoginData
        
        let jsonObj:JSON = str.toJSON() as! JSON
        
        let login = LoginResponseModel(json: jsonObj)
        
        OnlinePayment(LoginData: login!, cashback: Int(cashbackAmount))
     
    }
    
    func OnlinePayment(LoginData:LoginResponseModel,cashback:Int)
    {
        let dictionary = [
            "ipaddress" : LoginData.a_Id!,
            "ShippingCustomerName" : LoginData.sName!,
            "ShippingEmail" : LoginData.email!,
            "ShippingAddress" : LoginData.sAddress!,
            "ShippingMobileNo" : LoginData.mobileNo!,
            "ShippingCity" : LoginData.sCity!,
            "Shippingstate" : LoginData.sStateID!,
            "shippingPinCode" : LoginData.sPincode!,
            "Cashbackamount" : cashback,
            "cardnumber" : "",
            "Nameofcard" : ""
            ] as [String : Any]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_ONLINEPAYMENT ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                
                if(statusCode==200)
                {
                   Utility.hideProgressHud()
                    
                    let VC:PaymentPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentPageViewController") as! PaymentPageViewController
                    
                    VC.email = UserDeafultsManager.SharedDefaults.Username
                    VC.amount = String(self.cartAmount+self.cashbackAmount);
                    VC.firstname = UserDeafultsManager.SharedDefaults.FirstName
                    VC.phone = UserDeafultsManager.SharedDefaults.MobileNo
                    VC.productInfo="Product_purchase"
                    self.navigationController?.pushViewController(VC, animated: true)
                    
                }else{
                     Utility.hideProgressHud()
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
                
            }else{
                 Utility.hideProgressHud()
                let info = ["title":"Error",
                            "message":error,
                            "cancel":"Ok"]
                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
            }
            
        }
    }
    
    
    
    func CashOnDelivery(LoginData:LoginResponseModel,cashback:Int)
    {
        Utility.showProgressHud(text: "");
        
        let dictionary = [
            "ipaddress" : LoginData.a_Id!,
            "ShippingCustomerName" : LoginData.sName!,
            "ShippingEmail" : LoginData.email!,
            "ShippingAddress" : LoginData.sAddress!,
            "ShippingMobileNo" : LoginData.mobileNo!,
            "ShippingCity" : LoginData.sCity!,
            "Shippingstate" : LoginData.sStateID!,
            "shippingPinCode" : LoginData.sPincode!,
            "Cashbackamount" : cashback
            ] as [String : Any]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_CASHONDELIVERY ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                
                if(statusCode==200)
                {
                     Utility.hideProgressHud()
                   let aStr = String(format: "Your order has confirmed. You need to pay total amount % If you have any query call us 011-45727796.",self.lblPayableAmount.text!)
                    
                    self.SendMessage(phoneNo: "9799888646", Message: aStr)
                    
                    
                    let aStr1 = String(format: "Order has been confirmed. Payment of Rs. %                        \nEmail Address : % \nName : % \nMobile no : %",self.lblPayableAmount.text!,LoginData.email!,LoginData.sName!,LoginData.mobileNo!)
                    
                    self.SendMessage(phoneNo: "9799888646", Message: aStr1)
                    
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController")
                    self.navigationController?.pushViewController(VC!, animated: true)
                    
                    
                }else{
                     Utility.hideProgressHud()
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
                
            }else{
                 Utility.hideProgressHud()
                let info = ["title":"Error",
                            "message":error,
                            "cancel":"Ok"]
                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
            }
            
        }
    }
    
   
    func SendMessage(phoneNo:String, Message:String)
    {
        let dictionary = [
            "sendto" : phoneNo,
            "message" : Message,
            ]
        
        WebserviceCommunication.defaultCommunicator().httpGETEncodedString(methodName: METHOD_CASHBACK ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in

            
            if (data != nil)
            {
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                    
                    if(json != nil){
                        let dictionary = json as? [Any]
                        
                    }else{
                        let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    }
                } catch {
                    let info = ["title":"Error",
                                "message":"error in sending message",
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
                
            }else{
                let info = ["title":"Error",
                            "message":error,
                            "cancel":"Ok"]
                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
            }
        }
  
    }
    
  
    func CustomerCashback(username:String)
    {
        let dictionary = [
            "CustomerEmailID" : username,
            ]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_CASHBACK ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                    
                    if(json != nil){
                        let dictionary = json as? [Any]
                        
                        self.cashbackAmount = ("CashBackAmt" <~~ (dictionary?[0] as! JSON ))
                        
                    }else{
                        let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        self.cashbackAmount = 0.0;
                    }
                } catch {
                }
                
            }else{
                self.cashbackAmount = 0.0;
            }
            self.updateAmount()
        }
    }
    
    
    func DeleteItemFromCart(userID:Int)
    {
        let dictionary = [
            "ipaddress" : userID,
            ]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_DELETEITEMFROMCART ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                
                if(statusCode==200)
                {
                   // Utility.showToast(text: datastring! as String)
                   self.AddItemintoCart()
                    
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                    
                }
                
            }else{
                let info = ["title":"Error",
                            "message":error,
                            "cancel":"Ok"]
                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
            }
            
        }
    }
    
    func AddItemintoCart() {
        for product in CategoryItem.cartItemsArray {
            self.AddItemInToCart(product: product)
        }
    }
    
    
    func AddItemInToCart(product:ProductDetailsModel)
    {
        let dictionary = [
            "ProductID" : product.sKUID!,
            "itemSize" : product.uOMID!,
            "ipaddress" : UserDeafultsManager.SharedDefaults.MemberID,
            "quantity" : product.orderQty
            ] as [String : Any]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_INSERTITEMINTOCART ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            
            if (data != nil)
            {
                 let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                 print(datastring!)
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                    
                    if(json != nil){
                        let dictionary = json as? [Any]
                        
//                        let str:String = ("Result" <~~ (dictionary?[0] as! JSON ))!
//                        print(str)
                      //  Utility.showToast(text: str)
                        
                    }else{
                        let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                       // Utility.showToast(text: datastring! as String)
                    }
                } catch {
                }
                
            }else{
            }
            
        }
    }
    
    
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

