//
//  JSONDataProviderManager.swift
//  agilysUnitTest
//
//  Created by fauquette fred on 28/01/16.
//  Copyright © 2016 Agilys. All rights reserved.
//

import Foundation


class JSONDataProviderManager {
    static let sharedInstance = JSONDataProviderManager()
    
    private init(){
    }
    
    func jsonStringFromFile(fileName: String) -> String? {
        guard let jsonData = JSONDataFromFile(fileName) else {
            return nil
        }
        return String(data: jsonData, encoding: NSUTF8StringEncoding)
    }
    
    private func JSONDataFromFile(fileName: String) -> NSData? {
        if let str = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            return NSData(contentsOfFile: str)!
        } else {
            return nil
        }
    }
}