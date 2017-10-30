//
//  GroupCheckHelper.swift
//  Trendify
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class GroupCheckHelper: NSObject {
    
    class func groupHeading(groupPosition: Int , childItem: String) -> String {
        switch (groupPosition) {
        case 3:
            switch (childItem) {
            // This is for HomeFurnishing
            case "Bedsheet":
                return "HomeFurnishing";
            case "CushionCover":
                return "HomeFurnishing";
            case "Curtain":
                return "HomeFurnishing";
            case  "BeanBag":
                return "HomeFurnishing";
            case "Mat":
                return "HomeFurnishing";
            case "Carpet":
                return "HomeFurnishing";
            case "TableKitchen":
                return "HomeFurnishing";
                
            // This is for KitchenDining
            case "Container":
                return "KitchenDining";
            case "Mug":
                return "KitchenDining";
            case "Glassware":
                return "KitchenDining";
            case "DinnerSet":
                return "KitchenDining";
            case "Kitchen":
                return "KitchenDining";
            case "Dining":
                return "KitchenDining";
            case "Lunch":
                return "KitchenDining";
            case "Pots":
                return "KitchenDining";
            case "RotiMaker":
                return "KitchenDining";
            case "Mixer":
                return "KitchenDining";
            //This is for homeDecor
            case "TableDecor":
                return "HomeDecor";
            case "WallDecor":
                return "HomeDecor";
            case "GiftsItem":
                return "HomeDecor";
            case "Handicraft":
                return "HomeDecor";
            case "TableLamp":
                return "HomeDecor";
            case "TableClock":
                return "HomeDecor";
            case "WallClock":
                return "HomeDecor";
                
            //This is for Home Appliances
            case "Iron":
                return "HomeAppliances";
                
            //This is for Kitchen Appliances
            case "Microwave":
                return "KitchenAppliances";
            case "FoodProcessor":
                return "KitchenAppliances";
            case "InductionChulha":
                return "KitchenAppliances";
            case "ElectricKettle":
                return "KitchenAppliances";
            default :
                return "";
            }
        case 4:
            switch (childItem) {
            case "AllMobile":
                return "ElectronicsMobiles";
            default :
                return "";
            }
        case 5:
            switch (childItem) {
            //This is for KidsClothing
            case "BoysShirt":
                return "KidsClothing";
            case "BoysTShirt":
                return "KidsClothing";
            case "BoysJacket":
                return "KidsClothing";
            case "BoysShorts":
                return "KidsClothing";
            case "GirlsCloths":
                return "KidsClothing";
            case "BoysCloths":
                return "KidsClothing";
            case "GirlDress":
                return "KidsClothing";
            case "GirlTShirt":
                return "KidsClothing";
                
            //THis is for Kids Footwear
            case "BoysFootwear":
                return "KidsFootwear";
            case "GirlsFootwear":
                return "KidsFootwear";
                
            //This is for kids Accessories
            case "Sunglass":
                return "KidsAccessories";
            case "Bag":
                return "KidsAccessories";
            case "Watch":
                return "KidsAccessories";
                
            // This is for ToyGames
            case "Dolls":
                return "ToyGames";
            case "Construction":
                return "ToyGames";
            default :
                return "";
            }
            break;
        case 6:
            switch (childItem) {
            // This is for Books
            case "Educational":
                return "Books";
            case "Historical":
                return "Books";
            case "Novel":
                return "Books";
            case "Professional":
                return "Books";
                
            // This is for OfficeEquipment
            case "CorporateGifts":
                return "OfficeEquipment";
                
            // This is for Stationary
            case "Diary":
                return "Stationary";
                
            //This is for Bags
            case "Laptop":
                return "Bags";
            case "College":
                return "Bags";
            case "Trekking":
                return "Bags";
            default :
                return "";
            }
            
        default :
            return "";
        }
    }
    
    
    class func isHeadingExist(groupItem: String , childItem: String) -> Bool {
        switch (groupItem) {
        case "Grocery":
            switch (childItem) {
            case "Grocery/Staples":
                return true;
            default :
                return false;
            }
            break;
        case "Men":
            switch (childItem) {
            case "Men Clothing":
                return true;
            case "Men Footwear":
                return true;
            case "Men Accessories":
                return true;
            default :
                return false;
            }
            break;
        case "Women":
            switch (childItem) {
            case "Women Clothing":
                return true;
            case "Women Footwear":
                return true;
            case "Women Accessories":
                return true;
            case "Beauty & Cosmetics":
                return true;
            case "Lingerie, Sleep & Swimwear":
                return true;
            case "Jewellery":
                return true;
            case "Bags":
                return true;
            default :
                return false;
            }
            
            break;
        case "Home & Lifestyle":
            switch (childItem) {
            case "Home Furnishing":
                return true;
            case "Kitchen & Dinning":
                return true;
            case "Home Decor":
                return true;
            case "Home Appliances":
                return true;
            case "Kitchen Appliances":
                return true;
            default :
                return false;
            }
            break;
        case "Electronics":
            switch (childItem) {
            case "Mobile Accessories":
                return true;
            case "Computer Accessories":
                return true;
            default :
                return false;
            }
            break;
        case "Kids":
            switch (childItem) {
            case "Kids Clothing":
                return true;
            case "Kids Footwear":
                return true;
            case "Kids Accessories":
                return true;
            case "Toy and Games":
                return true;
            default :
                return false;
            }
            break;
        case "Books & Stationary":
            switch (childItem) {
            case "Books":
                return true;
            case "Office Equipment":
                return true;
            case "Bags & Luggage":
                return true;
            case "Stationary":
                return true;
            default :
                return false;
            }
        default :
            return false;
        }
    }
    
    class func isTextHeading(groupItem: String , childItem: String) -> Bool {
        switch (groupItem) {
        case "Grocery":
            switch (childItem) {
            case "Grocery/Staples":
                return true;
            case "Milk":
                return true;
            default :
                return false;
            }
            break;
        case "Men":
            switch (childItem) {
            case "Men Clothing":
                return true;
            case "Men Footwear":
                return true;
            case "Men Accessories":
                return true;
            default :
                return false;
            }
            break;
        case "Women":
            switch (childItem) {
            case "Women Clothing":
                return true;
            case "Women Footwear":
                return true;
            case "Women Accessories":
                return true;
            case "Beauty & Cosmetics":
                return true;
            case "Lingerie, Sleep & Swimwear":
                return true;
            case "Jewellery":
                return true;
            case "Bags":
                return true;
            default :
                return false;
            }
            break;
        case "Home & Lifestyle":
            switch (childItem) {
            case "Home Furnishing":
                return true;
            case "Kitchen & Dinning":
                return true;
            case "Home Decor":
                return true;
            case "Home Appliances":
                return true;
            case "Kitchen Appliances":
                return true;
            default :
                return false;
            }
            break;
        case "Electronics":
            switch (childItem) {
            case "Mobile Accessories":
                return true;
            case "Computer Accessories":
                return true;
            default :
                return false;
            }
            break;
        case "Kids":
            switch (childItem) {
            case "Kids Clothing":
                return true;
            case "Kids Footwear":
                return true;
            case "Kids Accessories":
                return true;
            case "Toy & Games":
                return true;
            default :
                return false;
            }
            break;
        case "Books & Stationary":
            switch (childItem) {
            case "Books":
                return true;
            case "Office Equipment":
                return true;
            case "Bags & Luggage":
                return true;
            case "Stationary":
                return true;
            default :
                return false;
            }
        default :
            return false;
        }
    }
}

