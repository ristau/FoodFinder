//
//  DetailViewController.swift
//  FoodFinder
//
//  Created by Barbara Ristau on 1/16/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var business: Business! 

  @IBOutlet weak var nameLabel: UILabel!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      nameLabel.text = business.name
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
