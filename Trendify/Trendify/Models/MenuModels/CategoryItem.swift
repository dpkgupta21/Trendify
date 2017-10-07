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
        headerPositions = ("headerPositions" <~~ json)!
        nonClickablePostion = ("nonClickablePostion" <~~ json)!
        isExpanded = false;
    }
}
