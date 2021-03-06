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
  @IBOutlet weak var openNowLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
      loadLabels()
      styleBusinessImage()
      styleBackgroundImage()
      
      let centerLocation = CLLocation(latitude: business.latitude!, longitude: business.longitude!)
      goToLocation(location: centerLocation)
      addAnnotationAtCoordinate(coordinate: business.coordinate!)

}
  
  func loadLabels() {
    
    nameLabel.text = business.name
    
    if business.imageURL != nil {
      businessImage.setImageWith(business.imageURL!)
    } else {
      businessImage.image = #imageLiteral(resourceName: "placeholder32")
    }
    
    backgroundImageView.setImageWith(business.imageURL!)
    ratingImage.setImageWith(business.ratingImageURL!)
    addressLabel.text = business.address
    phoneLabel.text = business.phone
    distanceLabel.text = business.distance
    reviewCountLabel.text = ("\(business.reviewCount!) Reviews")
    categoriesLabel.text = business.categories
    openNow()
    
    
  }
  
  func openNow() {
    
    // Background Note:  This field from the Yelp API actually refers to whether the business is permanently closed
    // (and not whether it is open now at this time)
    // Field is included for display purposes only and set to true as a default

    business.openNow = true // default setting for display 
    
    if business.openNow {
      openNowLabel.text = "Open Now"
      openNowLabel.textColor = UIColor.green
    } else {
      openNowLabel.text = "Closed"
      openNowLabel.textColor = UIColor.red
    }
    
  }
  

  //MARK: - Styling Methods
  
  func styleBusinessImage() {
    
    // Style the business profile image
    businessImage.layer.cornerRadius = self.businessImage.frame.size.width/2
    businessImage.clipsToBounds = true
    businessImage.layer.borderWidth = 1.5
    businessImage.layer.borderColor = UIColor.lightGray.cgColor

  }
  
  func styleBackgroundImage() {
    
    // Add blur effect to background image
    let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
    let blurEffectView = UIVisualEffectView(effect: blur)
    blurEffectView.frame = backgroundImageView.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    backgroundImageView.addSubview(blurEffectView)

  }
  
  // MARK: - MapKit Methods
  
  func goToLocation(location: CLLocation) {
    
    let span = MKCoordinateSpanMake(0.005, 0.005)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    mapView.setRegion(region, animated: false)
    
  }
  
  func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = business.name
    annotation.subtitle = business.address
    mapView.addAnnotation(annotation)
  }
  
  @IBAction func callNumber(_ sender: Any) {
    
    let prefix = "telprompt://"
    
    if business.phoneUrl != nil {
      let url:URL = URL(string: prefix + business.phoneUrl!)!
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
         print("Calling number: \(url)")
    } else {
        let alert = UIAlertView()
        alert.title = "Sorry!"
        alert.message = "Phone number is not available for this business"
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
  }
  
  
  
  

  
}
