//
//  LoginResponseModel.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 08/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class LoginResponseModel: Decodable {
    
    public var a_Id : Int?
    public var name : String?
    public var password : String?
    public var email : String?
    public var address : String?
    public var pincode : String?
    public var mobileNo : String?
    public var city : String?
    public var stateID : Int?
    public var sName : String?
    public var sPhone : String?
    public var sAddress : String?
    public var sPincode : String?
    public var sCity : String?
    public var sStateID : Int?
    public var registerDate : String?
    public var customerCashBackAmount : Int?
    
    public required init?(json: JSON) {
        a_Id = ("A_Id" <~~ json)
        name = ("Name" <~~ json)
        password = ("Password" <~~ json)
        email = ("Email" <~~ json)
        address = ("Address" <~~ json)
        pincode = ("Pincode" <~~ json)
        mobileNo = ("MobileNo" <~~ json)
        city = ("City" <~~ json)
        stateID = ("StateID" <~~ json)
        sName = ("SName" <~~ json)
        sPhone = ("SPhone" <~~ json)
        sAddress = ("SAddress" <~~ json)
        sPincode = ("SPincode" <~~ json)
        sCity = ("SCity" <~~ json)
        sStateID = ("SStateID" <~~ json)
        registerDate = ("RegisterDate" <~~ json)
        customerCashBackAmount = ("CustomerCashBackAmount" <~~ json)
    }
    
    required public init?(dictionary: NSDictionary) {
        
        a_Id = dictionary["A_Id"] as? Int
        name = dictionary["Name"] as? String
        password = dictionary["Password"] as? String
        email = dictionary["Email"] as? String
        address = dictionary["Address"] as? String
        pincode = dictionary["Pincode"] as? String
        mobileNo = dictionary["MobileNo"] as? String
        city = dictionary["City"] as? String
        stateID = dictionary["StateID"] as? Int
        sName = dictionary["SName"] as? String
        sPhone = dictionary["SPhone"] as? String
        sAddress = dictionary["SAddress"] as? String
        sPincode = dictionary["SPincode"] as? String
        sCity = dictionary["SCity"] as? String
        sStateID = dictionary["SStateID"] as? Int
        registerDate = dictionary["RegisterDate"] as? String
        customerCashBackAmount = dictionary["CustomerCashBackAmount"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.a_Id, forKey: "A_Id")
        dictionary.setValue(self.name, forKey: "Name")
        dictionary.setValue(self.password, forKey: "Password")
        dictionary.setValue(self.email, forKey: "Email")
        dictionary.setValue(self.address, forKey: "Address")
        dictionary.setValue(self.pincode, forKey: "Pincode")
        dictionary.setValue(self.mobileNo, forKey: "MobileNo")
        dictionary.setValue(self.city, forKey: "City")
        dictionary.setValue(self.stateID, forKey: "StateID")
        dictionary.setValue(self.sName, forKey: "SName")
        dictionary.setValue(self.sPhone, forKey: "SPhone")
        dictionary.setValue(self.sAddress, forKey: "SAddress")
        dictionary.setValue(self.sPincode, forKey: "SPincode")
        dictionary.setValue(self.sCity, forKey: "SCity")
        dictionary.setValue(self.sStateID, forKey: "SStateID")
        dictionary.setValue(self.registerDate, forKey: "RegisterDate")
        dictionary.setValue(self.customerCashBackAmount, forKey: "CustomerCashBackAmount")
        
        return dictionary
    }
    
    
    static func Login(username:String,password:String,callback:@escaping (_ result:LoginResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "CustomerEmail" : username,
            "CustomerPassword":password
        ]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_LOGIN ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data!)
                } catch {
                }
                if(json != nil){
                   let dictionary = json as? [Any]
                    if((dictionary?.count)! > 0){
                    let login = LoginResponseModel(json: dictionary?[0] as! JSON)
                        callback(login,"")
                    }else{
                        callback(nil,"No user found")
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
