//
//  FilterViewController.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/18/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
    var selectedCategoryName: String!
  
    var categories = [
    "American",
    "French",
    "Greek",
    "German",
    "Indian",
    "Italian",
    "Mexican",
    "Peruvian",
    "Pizza",
    "Portugese",
    "Thai",
    ]

    var selectedIndexPath = IndexPath()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView.dataSource = self
      tableView.delegate = self
      
      navigationItem.title = "Select Category"
      
      for i in 0..<categories.count {
        
        if categories[i] == selectedCategoryName {
          selectedIndexPath = IndexPath(row: i, section: 0)
          break
        }
      }
      
     print("Selected Category: \(selectedCategoryName!)")

   }


  //MARK: - TableView Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let categoryName = categories[indexPath.row]
    cell.textLabel!.text = categoryName
    print(categoryName)
    
    if categoryName == selectedCategoryName {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row != selectedIndexPath.row {
      if let newCell = tableView.cellForRow(at: indexPath) {
        newCell.accessoryType = .checkmark
      }
      if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
        oldCell.accessoryType = .none
      }
      selectedIndexPath = indexPath
    }
  }
  
  
  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "SelectedCategory" {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
          selectedCategoryName = categories[indexPath.row]
        }
      }
      
    }
  }
