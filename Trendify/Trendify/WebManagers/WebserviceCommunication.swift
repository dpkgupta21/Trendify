//  WebserviceCommunication.swift
//  TNLAgency
//

//  Created by Jatin sharan on 15/04/16.
//  Copyright © 2016 Ps. All rights reserved.
//

import Foundation

//FREQUENTLY USED WEBSERVICE KEY
let WEBSERVICE_HEADER_KEY              :String  = "header"
let WEBSERVICE_CLASS_DATA              :String  = "data"
let WEBSERVICE_CLASS_RESULT            :String  = "result"
let WEBSERVICE_CLASS_KEY               :String  = "class"
let WEBSERVICE_CLASS_SUCCESS           :String  = "success"
let WEBSERVICE_CLASS_ERROR             :String  = "error"
let WEBSERVICE_MESSAGE_KEY             :String  = "message"
let WEBSERVICE_TYPE_KEY                :String  = "type"
let WEBSERVICE_ATTRIBUTE_KEY           :String  = "attribute"
let WEBSERVICE_CODE_KEY                :String  = "code"
let WEBSERVICE_UNIT_KEY                :String  = "unit"

let WEBSERVICE_RESULT_KEY              :Bool    =  true

let timeInterval                       : TimeInterval = 300.0
let vimeotimeInterval                  : TimeInterval = 3000.0

let kTNLDebugLevel1:Bool = true  // Show debug level NSLOG
let kTNLDebugLevel2:Bool = true  // Show debug level NSLOG
let kTNLDebugLevel3:Bool = true  // Show debug level NSLOG
let kTNLDebugError:Bool  = true   // Show error NSLOG

let baseURL = "http://webservice.trendyfy.com/myservice.asmx/";

let sendMessageURL = "http://103.16.142.193/api.php?username=trendyfy&password=kishor&sender=TRNDFY"
let METHOD_LOGIN = "CustomerloginJSON"
let METHOD_HOMEITEMS = "MainMasterMobileJSON"
let METHOD_PRODUCTLISTITEMS = "GetProductJSONnew"
let METHOD_PRODUCTDETAILS = "GetProductJSON"
let METHOD_GETTERMINALS = "fetchTerminals"
let METHOD_GETROLLCALL = "FetchRollCall"
let METHOD_GETBUTTONSTATUS = "CheckForButtonsStatus"
let METHOD_CASHBACK = "GetCustomerCashBack"
let METHOD_DELETEITEMFROMCART = "DeleteItemFromChartJSON"
let METHOD_INSERTITEMINTOCART = "InsertItemIntoChartJSON"
let METHOD_CASHONDELIVERY = "InsertIntopaymentMasterJSON"
let METHOD_STATELIST = "GeStateJSON"
let METHOD_SIGNUP = "CustomerRegistrationJSON"
let METHOD_UPDATEPROFILE = "CustomerShippingDetailJSON"
let METHOD_ONLINEPAYMENT = "InsertIntopaymentMasterOnlinePaymentJSON"
let METHOD_ONLINEPAYMENTSUCCESS = "InsertIntopaymentMasterforsuccessJSON"

let extraStr1 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://tempuri.org/\">"
let extraStr2 = "</string>"

class WebserviceCommunication: NSObject,URLSessionDownloadDelegate,URLSessionTaskDelegate{
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    
    private static let _sharedInstance = WebserviceCommunication()
    
    
    class func defaultCommunicator() -> WebserviceCommunication {
        return _sharedInstance
    }
    
    
    func httpPOSTEncodedString(methodName:String,body:NSDictionary,callback:@escaping (_ result:Data?,_ statusCode:Int? ,_ error:NSString?)->Void)
    {
        //Request on background thread
        DispatchQueue.global(qos: .background).async {
            
            if(!Utility.isConnectedToNetwork())
            {
                callback(nil,nil , "No Internet Connection")
                return;
            }
            
            let requestURL = baseURL + methodName
            
            let url = NSURL(string: requestURL)
            
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeInterval)
            
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            
            do {
                
                var valuesString:String = "";
                for (key, var value) in body {
                    if let quantity = value as? NSNumber {
                        value = "\(quantity)"
                    }
                    valuesString += ((key as! String) + "=" + (value as! String) + "&");
                }
                
                
                let jsonData =  valuesString.data(using: String.Encoding.utf8)
                request.httpBody = jsonData
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    if error != nil {
                        callback(nil , 0 , error?.localizedDescription as NSString?)
                    } else {
                        let dataTaskResponse : HTTPURLResponse = response as! HTTPURLResponse
                        
                        if data == nil {
                            callback(nil, dataTaskResponse.statusCode , "Error")
                        }
                        else {
                            var datastring = String(data: data!, encoding: String.Encoding.utf8)
                            datastring = datastring?.replacingOccurrences(of: extraStr1, with: "")
                            datastring = datastring?.replacingOccurrences(of: extraStr2, with: "")
                            let jsonData =  datastring?.data(using: String.Encoding.utf8)!
                            callback(jsonData, dataTaskResponse.statusCode ,nil)
                        }
                    }
                }
                
                task.resume()
            }catch{
            
            }
            
        }
        
    }
    
    
    
    func httpGETEncodedString(methodName:String,body:NSDictionary,callback:@escaping (_ result:Data?,_ statusCode:Int? ,_ error:NSString?)->Void)
    {
        //Request on background thread
        DispatchQueue.global(qos: .background).async {
            
            if(!Utility.isConnectedToNetwork())
            {
                callback(nil,nil , "No Internet Connection")
                return;
            }
            
            var valuesString:String = "";
            for (key, var value) in body {
                if let quantity = value as? NSNumber {
                    value = "\(quantity)"
                }
                valuesString += ((key as! String) + "=" + (value as! String) + "&");
            }
            
          let requestURL = NSString(format:"%@&%@",sendMessageURL,valuesString)
            
            let urlStr : NSString = requestURL.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            
            let url = NSURL(string: urlStr as String)
            
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeInterval)
            
            request.httpMethod = "GET"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            
            do {
                
               
                
                
//                let jsonData =  valuesString.data(using: String.Encoding.utf8)
//                request.httpBody = jsonData
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    if error != nil {
                        callback(nil , 0 , error?.localizedDescription as NSString?)
                    } else {
                        let dataTaskResponse : HTTPURLResponse = response as! HTTPURLResponse
                        
                        if data == nil {
                            callback(nil, dataTaskResponse.statusCode , "Error")
                        }
                        else {
                            var datastring = String(data: data!, encoding: String.Encoding.utf8)
                            datastring = datastring?.replacingOccurrences(of: extraStr1, with: "")
                            datastring = datastring?.replacingOccurrences(of: extraStr2, with: "")
                            let jsonData =  datastring?.data(using: String.Encoding.utf8)!
                            callback(jsonData, dataTaskResponse.statusCode ,nil)
                        }
                    }
                }
                
                task.resume()
            }catch{
                
            }
            
        }
        
    }
    
}
