//
//  HomeResponseModel.swift
//  Trendify
//
//  Created by Deepak Gupta on 12/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class HomeResponseModel: Decodable {

    public var a_ID : Int?
    public var pageType : String?
    public var itemType : String?
    public var image1 : String?
    public var categoryid : Int?
    
    public required init?(json: JSON) {
        a_ID = ("A_Id" <~~ json)
        pageType = ("PageType" <~~ json)
        itemType = ("ItemType" <~~ json)
        image1 = ("Image1" <~~ json)
        categoryid = ("Categoryid" <~~ json)
        
    }
    
    static func GetItems(callback:@escaping (_ result:[HomeResponseModel]?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "A_ID" : ""
        ]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_HOMEITEMS ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                var categoryItems:[HomeResponseModel] = [HomeResponseModel]()
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                } catch {
                }
                if(json != nil){
                    let dictionary = json as? [Any]
                    if((dictionary?.count)! > 0){
                        for var item in (dictionary)!{
                            
                            let Item = HomeResponseModel(json: item as! JSON)
                            categoryItems.append(Item!)
                        }
                        callback(categoryItems,"")
                    }else{
                        callback(nil,"No items found")
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
