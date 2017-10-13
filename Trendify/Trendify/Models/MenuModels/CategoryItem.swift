//
//  CategoryIcon.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 21/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class CategoryItem: Decodable {
    
    public var category : String?
    public var categoryImageName : String?
    public var categoryNameForWebservice : String?
    public var subCategoryList : Array<String>?
    public var subCategoryListForWebservice : Array<String>?
    public var headerPositions:Array<Int>?
    public var nonClickablePostion:Array<Int>?
    public var isExpanded:Bool
    
    public required init?(json: JSON) {
        category = ("category" <~~ json)!
        categoryImageName = ("categoryImageName" <~~ json)!
        categoryNameForWebservice = ("categoryNameForWebservice" <~~ json)!
        subCategoryList = ("subCategoryList" <~~ json)!
        subCategoryListForWebservice = ("subCategoryListForWebservice" <~~ json)!
        headerPositions = ("headerPositions" <~~ json)
        nonClickablePostion = ("nonClickablePostion" <~~ json)
        isExpanded = false;
    }
    
    public static func GetMenuItems(completion: @escaping (_ data: [CategoryItem]) -> Void){
        
        DataManager.getTopAppsDataFromFileWithSuccess{
                (data) -> Void in
                var categoryItems:[CategoryItem] = [CategoryItem]()
                var json: (Any)? = nil
                do {
                    json = try JSONSerialization.jsonObject(with: data)
                } catch {
                }
                
                let dictionary = json as? [Any]
                
                for item in dictionary!{
                    categoryItems.append(CategoryItem(json: item as! [String : Any])!)
                }
                completion(categoryItems)
        }
        
    }
    
}
