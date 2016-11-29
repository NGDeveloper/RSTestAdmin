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
    let kBaseURL = "https://ethereal-zodiac-121821.appspot.com/";
//    let kBaseURL = "http://localhost:8888/";
    
    func getPropertiesListWithCompletion(_ completion: @escaping (_ properties: Array<AnyObject>?) -> Void) {
        Alamofire.request(kBaseURL + "properties").responseJSON { (response) in
            print(response.request!)  // original URL request
            print(response.response!) // URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value as? [String:Any] {
                print("JSON: \(response.result.value)")
                let propertiesArray = JSON["properties"] as? Array<AnyObject>
                //                print("array: \(propertiesArray)")
                completion(propertiesArray)
            } else {
                completion(nil)
            }
        }
    }
    
    func createPropertyWithTitle(_ title: String, message: String, url: String, completion: ((_ error: NSError?) -> Void)?) {
        let params = ["title": title, "message" : message, "url" : url]
        
        Alamofire.request(kBaseURL + "properties",
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseString { (response) in
            print("\(response)")
                // TODO: Handle server response errors.
                if ((completion) != nil) {
                    completion!(nil)
                }
        }
    }
}
