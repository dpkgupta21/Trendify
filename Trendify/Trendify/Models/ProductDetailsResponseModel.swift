//
//  ProductDetailsResponseModel.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 15/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class ProductDetailsResponseModel {

    var ProductDetails : [ProductDetailsModel] = [ProductDetailsModel]()
    
    static func GetProductDetails(pageType:String,itemName:String,locationId:String,itemID:String,callback:@escaping (_ result:ProductDetailsResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "PageType" : pageType,
            "ItemName" : itemName,
            "strLocation":locationId,
            "strItemID":itemID
        ]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_PRODUCTDETAILS ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                let categoryItems : ProductDetailsResponseModel = ProductDetailsResponseModel()
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                } catch {
                }
                if(json != nil){
                    let dictionary = json as? [Any]
                    if((dictionary?.count)! > 0){
                        for var item in (dictionary)!{
                            
                            let Item = ProductDetailsModel(json: item as! JSON)
                            categoryItems.ProductDetails.append(Item!)
                        }
                        callback(categoryItems,"")
                    }else{
                        callback(nil,"No product found")
                    }
                }else{
                    let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    callback(nil,datastring)
                }
                
            }else{
                callback(nil,error)
            }
            
        }
    }
    
    
}
