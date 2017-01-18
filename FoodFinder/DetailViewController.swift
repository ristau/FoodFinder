//
//  DetailViewController.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking

class DetailViewController: UIViewController {
  
  var business: Business! 

  
  @IBOutlet weak var businessImage: UIImageView!
  @IBOutlet weak var ratingImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var reviewCountLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      navigationItem.title = business.name
    //  nameLabel.text = business.name
      businessImage.setImageWith(business.imageURL!)
      ratingImage.setImageWith(business.ratingImageURL!)
      addressLabel.text = business.address
      phoneLabel.text = business.phone
      distanceLabel.text = business.distance
      reviewCountLabel.text = ("\(business.reviewCount!) Reviews")
      categoriesLabel.text = business.categories
      
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
