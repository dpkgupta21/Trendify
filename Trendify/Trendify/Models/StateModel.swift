//
//  StateModel.swift
//  Trendify
//
//  Created by Ghanshyam Jain on 21/11/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class StateModel: Decodable {
    public var a_Id : Int?
    public var name : String?
    
    public required init?(json: JSON) {
        a_Id = ("A_ID" <~~ json)
        name = ("StateName" <~~ json)
    }
    required public init?(dictionary: NSDictionary) {
        
        a_Id = dictionary["A_ID"] as? Int
        name = dictionary["StateName"] as? String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.a_Id, forKey: "A_ID")
        dictionary.setValue(self.name, forKey: "StateName")
        return dictionary
    }
    
    static func StateList(callback:@escaping (_ result:[StateModel]?,_ error:NSString?)->Void)
    {
        let dictionary = NSDictionary()
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_STATELIST ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                  var categoryItems:[StateModel] = [StateModel]()
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                } catch {
                }
                if(json != nil){
                    let dictionary = json as? [Any]
                    if((dictionary?.count)! > 0){
                        for var item in (dictionary)!{
                            
                            let Item = StateModel(json: item as! JSON)
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
