//
//  FoodBusinessViewController.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class FoodBusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

  var businesses: [Business]?
  var filteredBusinesses: [Business]?
  var business: Business?
  
  @IBOutlet weak var tableView: UITableView!
  
  var searchBar: UISearchBar = UISearchBar()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
      
        self.navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
      
        fetchDataFromNetwork()
    
  }
  
     
 
    // MARK: - TableView Functions
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return filteredBusinesses?.count ?? 0
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
    
    business = filteredBusinesses?[indexPath.row]
    cell.business = business

    return cell
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
  
  // MARK: - Network Request 
  
  func fetchDataFromNetwork() {
    
    
    Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
      
      self.businesses = businesses
      self.filteredBusinesses = businesses
      self.tableView.reloadData()
      if let businesses = businesses {
        for business in businesses {
          print("Name: \(business.name!)")
          print("Address: \(business.address!)")
          print("Categories: \(business.categories!)")
        }
      }
    }
    )
    
    tableView.reloadData()
    
  }
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
