//
//  ModelStore.swift
//  PlaceAutocomplete
//
//  Created by Kaveh Vossoughi on 5/23/17.
//  Copyright © 2017 Kaveh Vossoughi. All rights reserved.
//

import UIKit

class ModelStore {
    
    static func jsonDictionaryFromData(_ data: Data?, keyForResult: String) -> [String : Any] {
        
        // No data, return an empty array
        guard let data = data else {
            print ("Error with Json")
            return [:]
        }
        
        // Parse the Data into a JSON Object
        let JSONObject = try! JSONSerialization.jsonObject(with: data)
        
        // Insist that this object must be a dictionary
        guard let JSONDictionary = JSONObject as? [String : Any] else {
            assertionFailure("Failed to parse data. data.length: \(data.count)")
            return [:]
        }
        
        // Print the object, for now, so we can take a look
        prettyPrint(JSONObject: JSONDictionary)
        
        let dictionaries = JSONDictionary[keyForResult] as! [String : Any]
        
        return dictionaries

    }
    
    static private func prettyPrint(_ JSONObject: Any) {
        let prettyData = try! JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted)
        let prettyString = String(data: prettyData, encoding: String.Encoding.utf8)
        print(prettyString ?? "No String Available")
    }
}
