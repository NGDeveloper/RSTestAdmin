//
//  RSAAPI.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 09.03.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//

import UIKit
import Alamofire

class RSAAPI: NSObject {
    static let sharedAPI = RSAAPI()
    
    func getPropertiesListWithCompletion(completion: (properties: Array<AnyObject>?) -> Void) {
        Alamofire.request(.GET, "https://ethereal-zodiac-121821.appspot.com/testjson")
        .responseJSON { (response) -> Void in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(response.result.value)")
                let propertiesArray = JSON["properties"] as? Array<AnyObject>
//                print("array: \(propertiesArray)")
                completion(properties: propertiesArray)
            } else {
                completion(properties: nil)
            }
            
            
        }
    }
}
