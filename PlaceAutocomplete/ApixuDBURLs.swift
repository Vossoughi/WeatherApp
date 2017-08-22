//
//  ApixuDBURLs.swift
//  PlaceAutocomplete
//
//  Created by Kaveh Vossoughi on 5/23/17.
//  Copyright © 2017 Kaveh Vossoughi. All rights reserved.
//

import Foundation

struct ApixuDBURLs {
    
    static func URLForResource(resource r: String, parameters p: [String : Any] = [:]) -> URL {
        
        // make mutable copies of the resource and parameters
        let resource = r
        var parameters = p
        
        // Add in the API Key
        parameters["key"] = ApixuDB.Constants.ApiKey
        
        // turn the remaining parameters into a string
        let paramString = parameterString(parameters)
        
        // Assemble the URL String
        let urlString = ApixuDB.Constants.BaseURL + resource + ApixuDB.Constants.Json + "?" + paramString
        
        // Create a URL
        let url = URL(string: urlString)!
        
        return url
    }
    
    // Translate a dictionary of key/values into a URL encoded parameter string
    fileprivate static func parameterString(_ parameters: [String : Any]) -> String {
        
        if parameters.isEmpty {
            return ""
        }
        
        // And array of strings. Each element will have the format "key=value"
        var urlKeyValuePairs = [String]()
        
        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            // Append it
            
            if let escapedValue = escapedValue {
                let keyValuePair = "\(key)=\(escapedValue)"
                urlKeyValuePairs.append(keyValuePair)
            } else {
                print("Warning: trouble escaping string \"\(stringValue)\"")
            }
        }
        
        // Create a single string, separated with &'s
        return urlKeyValuePairs.joined(separator: "&")
    }
}
