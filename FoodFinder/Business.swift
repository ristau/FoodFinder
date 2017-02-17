//
//  Business.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Business: NSObject {
  
  var name: String?
  var address: String = ""
  var phone: String?
  var phoneUrl: String?

  var imageURL: URL?
  var ratingImageURL: URL?

  var distance: String?
  var categories: String?
  var rating: NSNumber?
  var reviewCount: NSNumber?
  var openNow: Bool = true  // need to remove openNow, as this refers to whether the business is permanently closed 
  // add openNow as search term parameter in order to retrieve 
  
  var coordinates: NSDictionary?
  var coordinate: CLLocationCoordinate2D?
  var latitude: Double?
  var longitude: Double?
  
  init(dictionary: NSDictionary) {
    
    name = dictionary["name"] as? String
    
    let imageURLString = dictionary["image_url"] as? String
    if imageURLString != nil {
      imageURL = URL(string: imageURLString!)!
    } else {
      imageURL = nil
    }
    
    phone = dictionary["display_phone"] as? String
    if phone == nil {
      phone = ""
    }
    
    phoneUrl = dictionary["phone"] as? String
    if phoneUrl == nil {
      phoneUrl = ""
    }
    
    
    
    let location = dictionary["location"] as? NSDictionary
    if location != nil {
      let addressArray = location!["address"] as? NSArray
      if addressArray != nil && addressArray!.count > 0 {
        address = addressArray![0] as! String
      }
    
      let neighborhoods = location!["neighborhoods"] as? NSArray
      if neighborhoods != nil && neighborhoods!.count > 0 {
      if !address.isEmpty {
        address += ", "
        }
      address += neighborhoods![0] as! String
        }
      
      coordinates = location!["coordinate"] as? NSDictionary
      if coordinates != nil {
        latitude = coordinates!["latitude"] as? Double
        longitude = coordinates!["longitude"] as? Double
        coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
      }
      
      }


    let categoriesArray = dictionary["categories"] as? [[String]]
    if categoriesArray != nil {
      var categoryNames = [String]()
      for category in categoriesArray! {
        let categoryName = category[0]
        categoryNames.append(categoryName)
      }
      categories = categoryNames.joined(separator: ", ")
    } else {
      categories = nil
    }
    
    let distanceMeters = dictionary["distance"] as? NSNumber
    if distanceMeters != nil {
      let milesPerMeter = 0.000621371
      distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
    } else {
      distance = nil
    }
    
    let ratingImageURLString = dictionary["rating_img_url_large"] as? String
    if ratingImageURLString != nil {
      ratingImageURL = URL(string: ratingImageURLString!)
    } else {
      ratingImageURL = nil
    }
    
    
    openNow = dictionary["is_closed"] as! Bool
    rating = dictionary["rating"] as? NSNumber
    reviewCount = dictionary["review_count"] as? NSNumber
    
  }
  
  class func businesses(array: [NSDictionary]) -> [Business] {
    
    var businesses = [Business]()
    for dictionary in array {
      let business = Business(dictionary: dictionary)
      businesses.append(business)
    }
    return businesses
    
  }
  
  class func searchWithTerm(term: String, offset: Int, completion: @escaping([Business]?, Error?) -> Void) {
    
    _ = YelpClient.sharedInstance.searchWithTerm(term, offset: offset, completion: completion)
    
  }
  
  class func searchWithTerm(term: String, offset: Int, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
    
    _ = YelpClient.sharedInstance.searchWithTerm(term, offset: offset, sort: sort, categories: categories, deals: deals, completion: completion)

  }
  
  
  
  
  
  
  
}
