
import Foundation
import  UIKit
import SystemConfiguration


public class Utility{
    
    let kTNLDebugLevel1:Bool = true  // Show debug level NSLOG
    let kTNLDebugLevel2:Bool = true  // Show debug level NSLOG
    let kTNLDebugLevel3:Bool = true  // Show debug level NSLOG
    let kTNLDebugError:Bool  = true   // Show error NSLOG
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    private static let _instance = Utility()
    
    
    
    
    class func defaultUtility() -> Utility {
        return _instance
    }
    
    
    /**
     *
     * Function Name : dictionaryToJSONData
     *
     * @Description : It will convert Dictionary object to JSONObject, and return AnyObject (it cab be NSData Or String.
     it will return a string in case of any error occured.)
     *
     * @return AnyObject
     */
    
    func dictionaryToJSONData(dicData:NSDictionary)->AnyObject {
        do {
            let jsonData:NSData = try JSONSerialization.data(withJSONObject: dicData, options: []) as NSData
            
            return jsonData
        }
        catch let error as NSError {
            return error.localizedDescription as AnyObject
        }
    }
    
    /**
     *
     * Function Name : jsonStringToDictionary
     *
     * @Description : It will convert json string to Dictionary and return a Dictionary Object.
     *
     * @return AnyObject
     */
    func jsonStringToDictionary(jsonData:NSData) -> Any {
        do {
            let json:Any = try JSONSerialization.jsonObject(with: jsonData as Data, options: [])
            
            //            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            //
            //            if jsonString!.isKindOfClass(NSDictionary) {
            //                return json
            //            }
            //            else if jsonString!.isKindOfClass(NSMutableArray) {
            //                return json
            //            }
            //            else {
            //                return ""
            //            }
            
            return json
        }
        catch let error as NSError {
            if kTNLDebugError {
                print(error.localizedDescription)
            }
            
            return "" as Any
        }
    }
    
    /**
     *
     * Function Name : jsonStringToDictionaryExtra
     *
     * @Description : It will convert json string to Dictionary and return a Dictionary Object.
     *
     * @return AnyObject
     */
    func jsonStringToDictionaryExtra(jsonData:NSData) -> Any {
        do {
            let json:Any = try JSONSerialization.jsonObject(with: jsonData as Data, options: [])
            
            let jsonData:NSData = try JSONSerialization.data(withJSONObject: json, options: []) as NSData
            
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)
            
            return jsonString!
        }
        catch let error as NSError {
            if kTNLDebugError {
                print(error.localizedDescription)
            }
            
            return "" as Any
        }
    }
    
    /**
     *
     * Function Name : isValidEmail
     *
     * @Description : It will return true if provided email address is in valid format.
     *
     * @return AnyObject
     */
    func isValidEmail(emailAddress:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    
    /**
     *
     * Function Name : isEmptyString
     *
     * @Description : It will return true in case of non empty string.
     *
     *
     * @return AnyObject
     */
    class func isEmptyString(str:String)->Bool {
        let trimmed = str.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    
    /**
     * @Author : Chandan Kumar for Version_1.0 30/03/2016
     *
     * Function Name : showProgressHud
     *
     * @Description : This function show progress view over window.
     *
     * @Param : String -> text
     */
//    class func showProgressHud(text : String)
//    {
//        if (hud == nil)
//        {
//            hud = MBProgressHUD.init(window: UIApplication.sharedApplication().keyWindow!)
//            UIApplication.sharedApplication.keyWindow?.addSubview(hud)
//            hud.showAnimated(true)
//            hud.label.text = text
//        }
//        else
//        {
//            DispatchQueue.main.asynchronously(execute: {
//                //Hide progress view
//                if (hud != nil)
//                {
//                    hud.label.text = text
//                }
//            })
//        }
//    }
    
    
    /**
     * @Author : Chandan Kumar for Version_1.0 30/03/2016
     *
     * @Function Name : hideProgressHud
     *
     * @Description : This function hide progress view over window.
     */
//    class func hideProgressHud()
//    {
//        if(hud != nil) {
//            hud.hideAnimated(true)
//            hud.removeFromSuperview()
//            hud.delegate = nil
//            hud = nil
//        }
//    }
    
    /**
     * @Author : Chandan Kumar for Version_1.0 30/03/2016
     *
     * @Function Name : showAlertWithInfo
     *
     * @Description : This function use to show alert view with single button.
     *
     * @Param : NSDictionary -> infoDic
     */
    class func showAlertWithInfo(infoDic : NSDictionary)
    {
        var tag : Int = 0
        
        if (infoDic.object(forKey: "tag") != nil) {
            tag = ((infoDic.object(forKey: "tag") as AnyObject).integerValue)!
        }
        
        let alertView : UIAlertView = UIAlertView.init(title: infoDic.object(forKey: "title") as? String, message: infoDic.object(forKey: "message")as? String, delegate: infoDic.object(forKey: "delegate") as? UIAlertViewDelegate, cancelButtonTitle: infoDic.object(forKey: "cancel")as? String)
        alertView.tag = tag
        alertView.show()
    }
    
    /**
     * @Author : Chandan Kumar for Version_1.0 30/03/2016
     *
     * @Function Name : showAlertWithMultiButtonInfo
     *
     * @Description : This function use to show alert view with multiple button.
     *
     * @Param : NSDictionary -> infoDic
     */
    class func showAlertWithMultiButtonInfo(infoDic : NSDictionary)
    {
        var tag : Int = 0
        
        if (infoDic.object(forKey: "tag") != nil) {
            tag = ((infoDic.object(forKey: "tag") as AnyObject).integerValue)!
        }
        
        let alertView : UIAlertView = UIAlertView.init(title: infoDic.object(forKey: "title") as! String, message: infoDic.object(forKey: "message") as! String, delegate: infoDic.object(forKey: "delegate") as? UIAlertViewDelegate, cancelButtonTitle: infoDic.object(forKey: "cancel")as? String, otherButtonTitles: infoDic.object(forKey: "ok")as! String)
        alertView.tag = tag
        alertView.show()
    }
    
    class func isNameValid(inputString : String) -> Bool
    {
        let letters = NSCharacterSet.letters
        let range = inputString.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if range != nil {
            return true
        }
        else {
            return false
        }
    }
    
    
    /**
     * @Function name: scrollViewToCenterOfScreen
     *
     * @description: Set content Offset of UIScrollView according to input textField
     *
     * @return nil
     */
//    class func scrollViewToCenterOfScreen(scrollView : UIScrollView, theView : UIView)
//    {
//        let theViewY : CGFloat = theView.center.y
//        let applicationFrame : CGRect = UIScreen.main.applicationFrame
//        let avaliableHeight : CGFloat = applicationFrame.size.height - keyBoardHeight - 150
//        var y : CGFloat = theViewY - avaliableHeight / 2.0
//        
//        if(y<0) {
//            y = 0
//        }
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, y), animated: true)
//        }, completion: nil)
//    }
    
    /**
     * @Function name: scrollViewToZero
     *
     * @description: Set content Offset of UIScrollView to zero
     *
     * @return nil
     */
//    class func scrollViewToZero(scrollView : UIScrollView)
//    {
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
//            
//            UIApplication.sharedApplication().keyWindow?.endEditing(true)
//        }, completion: nil)
//    }
    
    /**
     * @Function name: getSubstractDateByDays
     *
     * @description: Substract date by input parameter substractDays
     *
     * @Param : NSDate -> date, Int -> substractDays
     *
     * @Return : NSDate -> WeekBeforeDate
     */
//    func getSubstractDateByDays(date : NSDate,substractDays : Int) -> NSDate
//    {
//        // Get todays date to set the monthly subscription expiration date
//        let dateComponents : NSDateComponents = NSDateComponents()
//        dateComponents.day = -substractDays
//        
//        let WeekBeforeDate : NSDate = NSCalendar.currentCalendar.dateByAddingComponents(dateComponents, toDate: date, options: [])!
//        
//        return WeekBeforeDate
//    }
    
    /**
     * @Function name: getSubstractDateByMonths
     *
     * @description: Substract date by input parameter substractMonths
     *
     * @Param : NSDate -> date, Int -> substractMonths
     *
     * @Return : NSDate -> monthBeforeDate
     */
//    class func getSubstractDateByMonths(date : NSDate,substractMonths : Int) -> NSDate
//    {
//        // Get todays date to set the monthly subscription expiration date
//        let dateComponents : NSDateComponents = NSDateComponents()
//        dateComponents.month = -substractMonths
//        
//        let monthBeforeDate : NSDate = NSCalendar.currentCalendar.dateByAddingComponents(dateComponents, toDate: date, options: [])!
//        
//        return monthBeforeDate
//    }
    
    
           //        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        //        label.numberOfLines = 0
        //        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //        label.attributedText = text
        //        label.sizeToFit()
        //        return label.frame.height
    }
    



