//
//  ProductDetailsModel.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 15/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class ProductDetailsModel: Decodable {

    public var uOMID : Int?
    public var sKUID : String?
    public var descrption : String?
    public var productName : String?
    public var image1 : String?
    public var modelName : String?
    public var itemId : Int?
    public var mRP : Int?
    public var sellingPrice : Int?
    public var size : String?
    public var color : String?
    public var avaliableQty : Int?
    
    public required init?(json: JSON) {
        uOMID = ("uOMID" <~~ json)
        sKUID = ("SKUID" <~~ json)
        productName = ("ProductName" <~~ json)
        image1 = ("Image1" <~~ json)
        modelName = ("ModelName" <~~ json)
        itemId = ("ItemId" <~~ json)
        mRP = ("MRP" <~~ json)
        sellingPrice = ("SellingPrice" <~~ json)
        size = ("Size" <~~ json)
        color = ("Color" <~~ json)
        avaliableQty = ("AvaliableQty" <~~ json)
        descrption = ("Descrption" <~~ json)
        
    }
    
}
