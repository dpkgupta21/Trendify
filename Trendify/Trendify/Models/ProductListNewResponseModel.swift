//
//  ProductListNewResponseModel.swift
//  Trendify
//
//  Created by APPLE on 12/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class ProductListNewResponseModel: Decodable {
   
    public var rOWNO : Int?
    public var sKUID : String?
    public var productName : String?
    public var image1 : String?
    public var modelName : String?
    public var itemId : Int?
    public var mRP : Int?
    public var sellingPrice : Int?
    
    public required init?(json: JSON) {
        rOWNO = ("ROWNO" <~~ json)
        sKUID = ("SKUID" <~~ json)
        productName = ("ProductName" <~~ json)
        image1 = ("Image1" <~~ json)
        modelName = ("ModelName" <~~ json)
        itemId = ("ItemId" <~~ json)
        mRP = ("MRP" <~~ json)
        sellingPrice = ("SellingPrice" <~~ json)

        
    }

    static func GetProductItems(pageType:String,itemName:String,locationId:String,groceryCategoryId:String,callback:@escaping (_ result:[ProductListNewResponseModel]?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "PageType" : pageType,
            "ItemName" : itemName,
            "strLocation":locationId,
            "strGrocerycategoryID":groceryCategoryId
        ]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_PRODUCTLISTITEMS ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                var categoryItems:[ProductListNewResponseModel] = [ProductListNewResponseModel]()
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                } catch {
                }
                if(json != nil){
                    let dictionary = json as? [Any]
                    if((dictionary?.count)! > 0){
                        for var item in (dictionary)!{
                            
                            let Item = ProductListNewResponseModel(json: item as! JSON)
                            categoryItems.append(Item!)
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
