//
//  DataProviderManager.swift
//  agilysUnitTest
//
//  Created by fauquette fred on 28/01/16.
//  Copyright © 2016 Agilys. All rights reserved.
//

import Foundation
import ObjectMapper

enum DataError: ErrorType {
    case NoData
    case Empty
    case Serialize(String)
}

protocol DataProviderProtocol {
    func jsonStringFromFile(fileName: String) -> String?
}


class DataProviderManager {
    /// the sharedInstance as this is a Singleton
    static let sharedInstance = DataProviderManager()
    
    var dataProvider: DataProviderProtocol = JSONDataProviderManager.sharedInstance
    
    private init(){
    }
    
    func getResult() throws -> [BingCustomSearchItemModel] {
        guard let jsonStr = dataProvider.jsonStringFromFile("bingsearchResult") else {
            throw DataError.NoData
        }
        guard let result = Mapper<BingCustomSearchResultModel>().map(jsonStr) else {
            throw DataError.Serialize(jsonStr)
        }
        guard let items = result.items else {
            throw DataError.Empty
        }
        let results = items.filter{$0.isValidThumbNail}
        if results.isEmpty {
            throw DataError.Empty
        }
        return results
    }
}

extension BingCustomSearchItemModel {
    var isValidThumbNail: Bool {
        return height >= 300
    }
}

/**
 *  a class used for Bing result handling
 */
struct BingCustomSearchResultModel: Mappable {
    var items: [BingCustomSearchItemModel]?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        items    <-     map["d.results"]
    }
}


/**
 *  a Bing search result item
 */
struct BingCustomSearchItemModel: Mappable {
    
    var imageURL: String?
    var imageId: String?
    var width: Int?
    var height: Int?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        imageURL        <-     map["Thumbnail.MediaUrl"]
        imageId         <-     map["ID"]
        width           <-     (map["Thumbnail.Width"], IntTransform())
        height          <-     (map["Thumbnail.Height"], IntTransform())
    }
}



public class IntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> Int? {
        if let value = value as? String {
            return Int(value)
        }
        return nil
    }
    
    public func transformToJSON(value: Int?) -> String? {
        if let value = value {
            return String(value)
        }
        return nil
    }
}

