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

let WEBSERVICE_JOB_KEY                 :String  = "job"
let WEBSERVICE_JOBID_KEY               :String  = "id"
let WEBSERVICE_STATUS_KEY              :String  = "status"
let WEBSERVICE_CHANGELOGIN             :String  = "change_required"
let WEBSERVICE_ISACTIVE                :String  = "active"
let WEBSERVICE_EXPIRES                 :String  = "expires"
let WEBSERVICE_RESULT_KEY              :Bool    =  true

let timeInterval                       : TimeInterval = 300.0
let vimeotimeInterval                  : TimeInterval = 3000.0

let kTNLDebugLevel1:Bool = true  // Show debug level NSLOG
let kTNLDebugLevel2:Bool = true  // Show debug level NSLOG
let kTNLDebugLevel3:Bool = true  // Show debug level NSLOG
let kTNLDebugError:Bool  = true   // Show error NSLOG

//TODO add base url
let baseURL = "";


class WebserviceCommunication: NSObject,URLSessionDownloadDelegate,URLSessionTaskDelegate{
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    
    private static let _sharedInstance = WebserviceCommunication()
    
    
    class func defaultCommunicator() -> WebserviceCommunication {
        return _sharedInstance
    }
    
    
    
    func checkIfRequestNotAuthorized(result:AnyObject)
    {
        var resObj:NSDictionary = NSDictionary();
        var errorCode = 0;
        if(!(result.value(forKey:WEBSERVICE_CLASS_ERROR) as AnyObject? is NSNull) && result.value(forKey: WEBSERVICE_CLASS_ERROR) != nil)
        {
            if (result.value(forKey:WEBSERVICE_CLASS_ERROR)! as AnyObject) is (NSMutableDictionary) || (result.value( forKey:WEBSERVICE_CLASS_ERROR)! as AnyObject) is (NSDictionary) {
                resObj = (result.value(forKey:WEBSERVICE_CLASS_ERROR)) as! NSDictionary;
            }
            else if (result.value(forKey:WEBSERVICE_CLASS_ERROR)! as AnyObject) is (NSMutableArray) || (result.value(forKey:WEBSERVICE_CLASS_ERROR)! as AnyObject) is (NSArray) {
                resObj = ((result.value(forKey:WEBSERVICE_CLASS_ERROR)) as! NSArray)[0] as! NSDictionary;
            }
            if(!(resObj.value(forKey: "code") as AnyObject? is NSNull) && resObj.value(forKey: "code") != nil){
                errorCode = (resObj.value(forKey: "code")) as! Int
            }
        }
        
        if errorCode == 401 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RequestNotAuthorized"),object: nil)
        }
    }
    
    
    // MARK:
    // MARK: Server request Helping methods
    // MARK:
    
    /**
     it will return the response against respective rquest.
     */
    func httpGET(methodName:String,body:NSDictionary,callback:@escaping (_ result:AnyObject,_ statusCode:Int? ,_ error:NSString?)->Void)
    {
        //Request on background thread
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            //Error check 1: Check internet availability
            if(!Utility.isConnectedToNetwork())
            {
                callback(["Message" : NSLocalizedString("LSNetErrorMsg", comment:"")] as AnyObject,nil , NSLocalizedString("LSErrorTitle", comment:"") as NSString?)
                return;
            }
            
            
            let obj = body.value(forKey: WEBSERVICE_CLASS_DATA)! as! NSDictionary
            
            var valuesString:String = "";
            for (key, var value) in obj {
                if let quantity = value as? NSNumber {
                    value = "\(quantity)"
                }
                valuesString += ((key as! String) + "=" + (value as! String) + "&");
            }
            
            valuesString = valuesString.trimmingCharacters(in: NSCharacterSet(charactersIn: "&") as CharacterSet)
            
            let characterSet = NSMutableCharacterSet() //create an empty mutable set
            characterSet.formUnion(with: NSCharacterSet.urlQueryAllowed)
            characterSet.removeCharacters(in:"+")
            
            let escapedString = valuesString.addingPercentEncoding( withAllowedCharacters: characterSet as CharacterSet)
            
            let requestURL = baseURL + methodName + "?" + escapedString!
            
            let url = NSURL(string: requestURL)
            
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeInterval)
            
            request.httpMethod = "GET"
           // request.addValue("application/form-data", forHTTPHeaderField: "Content-Type")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
          //  request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            for header in ((body.value(forKey: WEBSERVICE_HEADER_KEY) as! NSDictionary).allKeys) {
                request.addValue((body.value(forKey: WEBSERVICE_HEADER_KEY) as AnyObject).value(forKey: header as! String) as! String, forHTTPHeaderField: header as! String)
            }
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                
                if error != nil {
                    callback(["Message" : error?.localizedDescription as NSString?] as AnyObject,nil , NSLocalizedString("LSErrorTitle", comment:"") as NSString?)
                } else  {
                    let dataTaskResponse : HTTPURLResponse = response as! HTTPURLResponse
                    
                    if data == nil {
                        callback(["Message" : NSLocalizedString("LSServerErrorMessage", comment:"")] as AnyObject,nil , NSLocalizedString("LSErrorTitle", comment:"") as NSString?)
                    }
                    else {
                        let dictionary = Utility.defaultUtility().jsonStringToDictionary(jsonData: data! as NSData)
                        
                        self.checkIfRequestNotAuthorized(result: dictionary as AnyObject)
                        if (dictionary as AnyObject).isKind(of:NSMutableDictionary.self) || (dictionary as AnyObject).isKind(of:NSMutableArray.self) || (dictionary as AnyObject).isKind(of:NSDictionary.self) || (dictionary as AnyObject).isKind(of:NSArray.self) {
                            callback(dictionary as AnyObject, dataTaskResponse.statusCode ,nil)
                        }
                        else
                        {
                            callback(["Message" : NSLocalizedString("LSServerErrorMessage", comment:"")] as AnyObject,nil , NSLocalizedString("LSErrorTitle", comment:"") as NSString?)
                        }
                    }
                    
                    _ = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                }
            }
            
            task.resume()
        }
    }
    
    
    
    func httpPOSTEncodedString(methodName:String,body:NSDictionary,callback:@escaping (_ result:AnyObject,_ statusCode:Int? ,_ error:NSString?)->Void)
    {
        //Request on background thread
        DispatchQueue.global(qos: .background).async {
            
            // TODO : net check
            //Error check 1: Check internet availability
            if(!Utility.isConnectedToNetwork())
            {
                callback("" as AnyObject,nil , NSLocalizedString("LSNetErrorMsg", comment:"") as NSString?)
                return;
            }
            
            let requestURL = baseURL + methodName
            
            let url = NSURL(string: requestURL)
            
            let request = NSMutableURLRequest(url: url as! URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeInterval)
            
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            for header in ((body.value(forKey: WEBSERVICE_HEADER_KEY) as! NSDictionary).allKeys) {
                request.addValue((body.value(forKey: WEBSERVICE_HEADER_KEY) as AnyObject).value(forKey:header as! String) as! String, forHTTPHeaderField: header as! String)
            }
            
            do {
                let obj = body.value(forKey: WEBSERVICE_CLASS_DATA)! as! NSDictionary
                
                var valuesString:String = "";
                for (key, var value) in obj {
                    if let quantity = value as? NSNumber {
                        value = "\(quantity)"
                    }
                    valuesString += ((key as! String) + "=" + (value as! String) + "&");
                }
                //valuesString = "forename=Mrigraj&gender=Male&surname=Singh&attributes%5BHAI%5D=94"
                
                
                let jsonData:NSData =  valuesString.data(using: String.Encoding.utf8)! as NSData
                
                request.httpBody = jsonData as Data
                
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    if error != nil {
                        callback("" as AnyObject , 0 , error?.localizedDescription as NSString?)
                    } else {
                        let dataTaskResponse : HTTPURLResponse = response as! HTTPURLResponse
                        
                        if data == nil {
                            callback("" as AnyObject, dataTaskResponse.statusCode , "Error")
                        }
                        else {
                            let dictionary = Utility.defaultUtility().jsonStringToDictionary(jsonData: data! as NSData)
                            callback(dictionary as AnyObject, dataTaskResponse.statusCode ,nil)
                        }
                        
                        // var result = NSString(data: data!, encoding: NSASCIIStringEncoding)
                    }
                }
                
                task.resume()
            }
            
        }
        
    }
    
    
    
}
