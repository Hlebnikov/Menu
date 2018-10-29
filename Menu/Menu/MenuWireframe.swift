//
//  MenuWireframe.swift
//  VekaMeasurer
//
//  Created by Aleksandr X on 03.10.17.
//  Copyright © 2017 IceRock Development. All rights reserved.
//

import UIKit

class MenuWireframe {
  private let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
  private var menuController: MenuController?
  
  init(firstScreenIndex: Int = 0) {
    let controller = menuStoryboard.instantiateInitialViewController()
    if let container = controller as? ContainerViewController {
      container.setupFirstScreen(with: firstScreenIndex)
      menuController = MenuController(container: container)
    }
  }
  
  /// Рекомендуется для перехода без анимации
  func present(inWindow window: UIWindow) {
    let menuContainer = menuController?.menuContainer
    window.subviews.forEach { $0.removeFromSuperview() }
    window.rootViewController = menuContainer
  }
  
  func present(fromViewController viewController: UIViewController) {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let window = appDelegate.window,
      let menuController = menuController {
      viewController.present(menuController.menuContainer, animated: true) {
        MenuWireframe(firstScreenIndex: 0).present(inWindow: window)
      }
    }
  }
}
