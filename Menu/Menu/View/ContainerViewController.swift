//
//  StartViewController.swift
//  VekaMeasurer
//
//  Created by Aleksandr X on 03.10.17.
//  Copyright © 2017 IceRock Development. All rights reserved.
//

import UIKit

/**
 Класс контроллера-контейнера в который подставляются соответсвующие переходам класс
 Для настройки переходов править класс NavigationStore
 */

class ContainerViewController: UIViewController {
  
  var menuController: MenuController!
  var firstScreenIndex: Int = 0
  
  @IBAction func openMenu() {
    menuController.openMenu()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuController.openNavigation(by: firstScreenIndex)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    children.forEach { (vc) in
      vc.updateViewConstraints()
    }
  }
  
  func setupFirstScreen(with index: Int) {
    self.firstScreenIndex = index
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let menu = segue.destination as? MenuViewController {
      menu.menuController = menuController
      menu.transitioningDelegate = menuController
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }

}
