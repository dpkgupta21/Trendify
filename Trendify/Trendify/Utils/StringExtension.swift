//
//  StringExtension.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toInt() -> Int? {
        if let cost = Int(self) {
           return cost
        } else {
            return 0;
        }
    }
    
    func toFloat() -> Float? {
        if let cost = Float(self) {
            return cost
        } else {
            return 0;
        }
    }
    
    func toDouble() -> Double? {
        if let cost = Double(self) {
            return cost
        } else {
            return 0;
        }
    }
    func toDate(format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
   
    
}
