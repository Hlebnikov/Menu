//
//  MenuController.swift
//  VekaMeasurer
//
//  Created by Aleksandr X on 03.10.17.
//  Copyright © 2017 IceRock Development. All rights reserved.
//

import UIKit

/**
   Вся механика меню релизована здесь
*/

class MenuController: NSObject {
  var menuContainer: ContainerViewController!
  var menuViewController: UIViewController?
  
  let swipeInteractionController = SwipeMenuInteractionController()
  
  fileprivate var navigationsStore: NavigationsStore!
  fileprivate var interaction = true
  
  /// Готовая кнопка которую нужно вставлять в навигейшн бары контроллеров которые должны вызывать меню. 
  var menuButton: UIBarButtonItem {
    let button = UIBarButtonItem(image: UIImage(named: "menuButton"), style: .plain, target: self, action: #selector(openMenu))
    return button
  }
  
  init(container: ContainerViewController) {
    super.init()
    
    self.menuContainer = container
    container.menuController = self
    navigationsStore = NavigationsStore(menuController: self)
  }
  
  @objc func openMenu() {
    menuContainer.transitioningDelegate = self
    menuContainer.performSegue(withIdentifier: "showMenu", sender: nil)
    interaction = false
  }
  
  func closeMenu() {
    menuViewController?.dismiss(animated: true, completion: nil)
  }
  
  private func openViewController(_ viewController: UIViewController) {
    removeSubviews()

    menuContainer.addChild(viewController)
    menuContainer.view.addSubview(viewController.view)
    viewController.view.frame = menuContainer.view.bounds
    viewController.didMove(toParent: menuViewController)
    menuContainer.transitioningDelegate = self
    swipeInteractionController.wireToController(self)

    closeMenu()
  }
  
  func openControllerByDeepLink(_ viewController: UIViewController) {
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.topViewController?.navigationItem.leftBarButtonItem = self.menuButton
    openViewController(navigationController)
  }
  
  private func removeSubviews() {
    menuContainer.view.subviews.forEach { (subview) in
      subview.removeFromSuperview()
    }
  }
  
  func openNavigation(by index: Int) {
    let navigationType = navigationsStore.items[index]

    let navigation = navigationsStore.getNavigation(for: navigationType)
    openViewController(navigation)
  }
}

extension MenuController: UITableViewDataSource, UITableViewDelegate {
  // MARK: Table view data source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return navigationsStore.items.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    setupCell(cell, withType: navigationsStore.items[indexPath.row])
    return cell
  }
  
  private func setupCell(_ cell: UITableViewCell, withType directionType: DirectionType) {
    cell.textLabel?.text = navigationsStore.title(for: directionType)
    cell.backgroundColor = .clear
    cell.textLabel?.font = UIFont(name: cell.textLabel!.font.familyName, size: 16)
    cell.textLabel?.textColor = .white
    cell.selectionStyle = .none
  }
  
  // MARK: Table view Delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    openNavigation(by: indexPath.row)
  }
}

extension MenuController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let slideAnimation = SlideAnimation()
    slideAnimation.onComplete = { snapshot in
      self.swipeInteractionController.wireToBack(view: snapshot)
    }
    return slideAnimation
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissAnimation()
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
  }

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
  }
}
