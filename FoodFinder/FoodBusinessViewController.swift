//
//  FoodBusinessViewController.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FoodBusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
  
  var locationManager: CLLocationManager!

  var businesses: [Business]?
  var filteredBusinesses: [Business]?
  var business: Business?
  
  var searchTerm: String?
  
  // ScrollView & Activity Indicator
  var isMoreDataLoading = false
  var loadingMoreView: InfiniteScrollActivityView?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var mapView: MKMapView!
  var currentView: UIView!
  
  
  var searchBar: UISearchBar = UISearchBar()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
      
        // Set up nav Bar and initial view
        self.navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "map_medgrey")
        currentView = self.tableView
      
      
        // Set up search bar
        self.navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchTerm = "Greek"
      
        // Set up map view 
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
      
      
        mapView.delegate = self
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
      
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x:0, y: tableView.contentSize.height, width:tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
      
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
      
      
        // get Data from Network
        fetchDataFromNetwork()

  }

  
  // MARK: - Network Request
  
  func fetchDataFromNetwork() {
    
    Business.searchWithTerm(term: searchTerm!, completion: { (businesses: [Business]?, error: Error?) -> Void in
      
      self.businesses = businesses
      self.filteredBusinesses = businesses
    
      if let businesses = businesses {
        for business in businesses {
          
          print("Name: \(business.name!)")
          print("Address: \(business.address)")
          print("Phone: \(business.phone!)")
          print("Categories: \(business.categories!)")
         // print("Coordinate: \(business.coordinate!)")
          print("Open Now: \(business.openNow)")
          
        }
      }
      self.tableView.reloadData()

    }
    )
    
  }
  
  func fetchMoreData() {
    
    Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
      
      self.businesses = businesses
      self.filteredBusinesses = businesses
      
      self.isMoreDataLoading = false // update the flag
      self.loadingMoreView!.stopAnimating() // stop the loading indicator
      self.tableView.reloadData() // reload tableview
      
      if let businesses = businesses {
        for business in businesses {
          print("Name: \(business.name!)")
          print("Address: \(business.address)")
          print("Categories: \(business.categories!)")
        }
      }
    }
    )
    
  }
  
 
    // MARK: - TableView Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return filteredBusinesses?.count ?? 0
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
    
    business = filteredBusinesses?[indexPath.row]
    cell.business = business

    return cell
  }
  
  // MARK: - Filter Methods 
  
  @IBAction func filter(_ sender: Any) {
    
    print("pressed filter") 
    
    
    
  }
  
  
  

  
  
  
  // MARK: - Search Bar
  
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
    filteredBusinesses = searchText.isEmpty ? businesses : businesses?.filter({(business: Business) -> Bool in
      return (business.name!.range(of: searchText, options: .caseInsensitive) != nil)
    })
    
    tableView.reloadData()
 
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
    fetchDataFromNetwork()
  }
  
  
  // MARK: - ScrollView
  
  func scrollViewDidScroll(_ scrollView: UIScrollView){
    
    if(!isMoreDataLoading) {
      
      // determine whether we need to get more data 
      // this example is based on screen length 
      // switch to offset method using YelpAPI
      
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      
      // if user has scrolled past this pount
      if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
        isMoreDataLoading = true

        let frame = CGRect(x:0, y:tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()

        fetchMoreData()
        print("Fetching More Data")

      }
    }
  }
  
  // MARK: - MapKit Methods
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == CLAuthorizationStatus.authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let span = MKCoordinateSpanMake(0.05, 0.05)
      let region = MKCoordinateRegionMake(location.coordinate, span)
      mapView.setRegion(region, animated: false )
    }
  }
  
  
  func setDataForMap() {
    
    if let businesses = businesses {
      for business in businesses {
        self.addAnnotationAtCoordinate(coordinate: business.coordinate!, name: business.name!, address: business.address)
      }
    }
  }
  
  
  func goToLocation(location: CLLocation) {
    
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    mapView.setRegion(region, animated: false)
    
  }
  
  func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, name: String, address: String) {

    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = name
    annotation.subtitle = address
    mapView.addAnnotation(annotation)
  }
  
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    guard !(annotation is MKUserLocation) else { return nil }
    
    let identifier = "annotation" 
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotationView as! MKAnnotation?, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
      annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
    } else {
      annotationView?.annotation = annotation
    }
    
   return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

      performSegue(withIdentifier: "mapToDetail", sender: view)
    
    
  }
  
  
  // MARK: - Toggle and Load Views
  
  @IBAction func toggleView(_ sender: UIBarButtonItem) {
    
    if currentView == self.tableView {
      
      setDataForMap()
      loadMapView()
      
    } else if currentView == self.mapView {
      
      loadTableView()
      tableView.reloadData()
      
    }
    
    
  }
  
  func loadMapView(){
  
    
    navigationItem.rightBarButtonItem?.image = UIImage(named: "listgrid_medgrey24")
    navigationItem.titleView?.isHidden = true
    
    UIView.transition(from: self.tableView, to: self.mapView, duration: 0, options: .showHideTransitionViews, completion: nil)
    currentView = self.mapView
    
  }
  
  func loadTableView() {
    
    navigationItem.rightBarButtonItem?.image = UIImage(named: "map_medgrey")
    navigationItem.titleView?.isHidden = false
    
    UIView.transition(from: self.mapView, to: self.tableView, duration: 0, options: .showHideTransitionViews, completion: nil)
    currentView = self.tableView
    
  }
  
  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      print("preparing for segue")
      
      if segue.identifier == "TableView" {
        let detailvc = segue.destination as! DetailViewController


        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        business = businesses![(indexPath?.row)!]
              detailvc.business = business
     
      } else if segue.identifier == "mapToDetail" {
        
        // sender is currently of type MKAnnotationView
        // how to I retrieve the business object that is being displayed by the MKAnnotationView?
        
        
        let detailvc = segue.destination as! DetailViewController
        detailvc.business = business
 
      } else if segue.identifier == "Filter" {
        
        let filtervc = segue.destination as! FilterViewController
        
        
      }
      


    }

}
