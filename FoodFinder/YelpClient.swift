//
//  YelpClient.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import BDBOAuth1Manager

let yelpConsumerKey = "fHIvDY3aTk4OF4wYvpyc1g"
let yelpConsumerSecret = "_XVdpsVdV3y-C7YKmLRg1JU8Y4c"
let yelpToken = "uW8YPTUei-LtzYTlu1jAtZccl0Pp9vhD"
let yelpTokenSecret = "hVtnaBlPn9zbBdK7AtfOjLLplyA"

enum YelpSortMode: Int {
  case bestMatched = 0, distance, highestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
  
  var accessToken: String!
  var accessSecret: String!
  
  // MARK: Shared Instance 
  
  static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
    
    self.accessToken = accessToken
    self.accessSecret = accessSecret
    let baseUrl = URL(string: "https://api.yelp.com/v2/")
    
    super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret)
    
    let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
    
    self.requestSerializer.saveAccessToken(token)
  
  }
  
  func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {

    return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)

  }
  
  func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
    
    let limit: Int = 10
    let page: Int = 2
    let offset: Int = limit * page
   
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    
    // Default the location to San Francisco
    
    var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771, -122.406165" as AnyObject, "limit" : limit as AnyObject, "offset": offset as AnyObject]
    
    if sort != nil {
      parameters["sort"] = sort!.rawValue as AnyObject?
    }
    
    if categories != nil && categories!.count > 0 {
      parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
    }
    
    if deals != nil {
      parameters["deals_filter"] = deals! as AnyObject?
    }
    
    print(parameters)
    
    return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
      
      if let response = response as? [String: Any] {
        let dictionaries = response["businesses"] as? [NSDictionary]
        if dictionaries != nil {
          completion(Business.businesses(array: dictionaries!), nil)
        }
      }
    }, failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
      completion(nil, error)
    })!
  }
  
  
}
