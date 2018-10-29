//
//  MenuViewController.swift
//  VekaMeasurer
//
//  Created by Aleksandr X on 03.10.17.
//  Copyright © 2017 IceRock Development. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  
  var menuController: MenuController! {
    didSet {
      menuController.menuViewController = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = menuController
    tableView.delegate = menuController
  }
  
}
