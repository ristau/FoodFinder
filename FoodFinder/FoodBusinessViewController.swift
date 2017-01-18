//
//  FoodBusinessViewController.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import MapKit


class FoodBusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate{

  var businesses: [Business]?
  var filteredBusinesses: [Business]?
  var business: Business?
  
  // ScrollView & Activity Indicator
  var isMoreDataLoading = false
  var loadingMoreView: InfiniteScrollActivityView?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var mapView: MKMapView!
  
  
  var searchBar: UISearchBar = UISearchBar()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
      
        // Set up search bar
        self.navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
      
        // Set up map view 
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
    
    Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
      
      self.businesses = businesses
      self.filteredBusinesses = businesses
      self.tableView.reloadData()
      if let businesses = businesses {
        for business in businesses {
          print("Name: \(business.name!)")
          print("Address: \(business.address)")
          print("Phone: \(business.phone!)")
          print("Categories: \(business.categories!)")
          print("Latitude: \(business.latitude!)")
          print("Longitude: \(business.longitude!)")
          
        }
      }
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
  
  // MARK: - MapKit Methods
  
  func goToLocation(location: CLLocation) {
    
    let span = MKCoordinateSpanMake(0.1, 0.1)
    let region = MKCoordinateRegionMake(location.coordinate, span)
    mapView.setRegion(region, animated: false)
    
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
  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      print("preparing for segue")
      
      if segue.identifier == "TableView" {

        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        business = businesses![(indexPath?.row)!]
      }
      
      let detailvc = segue.destination as! DetailViewController
      detailvc.business = business

    }

}
