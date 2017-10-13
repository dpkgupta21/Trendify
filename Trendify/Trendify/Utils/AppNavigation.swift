//
//  AppNavigation.swift
//  Trendify
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class AppNavigation: NSObject {
    
    
    class func ChangeToProductVC(oldVC : UIViewController, pageType:String,categoryid:String,itemType:String){
        
        let VC = oldVC.storyboard?.instantiateViewController(withIdentifier: "ProductListNavVC") as! UINavigationController
        let pVC = VC.topViewController as! ProductListViewController
        pVC.pageType = pageType
        pVC.groceryCategoryId = categoryid
        pVC.itemName = itemType
        pVC.locationID = ""
        oldVC.revealViewController().frontViewController = VC;
        
    }
    
    class func ChangeToHomeVC(oldVC : UIViewController){
        
        let VC = oldVC.storyboard?.instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController
        oldVC.revealViewController().frontViewController = VC;
        
    }
    
    
}
