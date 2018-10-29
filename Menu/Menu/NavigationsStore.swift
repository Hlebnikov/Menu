//
//  NavigationsStore.swift
//  VekaMeasurer
//
//  Created by Aleksandr X on 04.10.17.
//  Copyright © 2017 IceRock Development. All rights reserved.
//

import UIKit

/// Прежде всего, добавь сюда новый пункт и компилятор покажет где чего не хватает.
enum DirectionType: Int, CaseIterable {
  case first = 1
  case second
  case third
  case fourth
  case fifth
}

/**
 Класс для настройки веток. Этот класс ответсвенен за имена пунктов меню и производство контроллеров.
*/
class NavigationsStore {
  var items: [DirectionType] {
    return DirectionType.allCases
  }
  
  private weak var menuController: MenuController!
  
  init(menuController: MenuController) {
    self.menuController = menuController
  }
  
  func title(for type: DirectionType) -> String {
    return "\(type.rawValue) пункт меню"
  }

  /// Возвращает навигейшн контроллер который будет подставлен в наш контейнер
  func getNavigation(for type: DirectionType) -> UINavigationController {
    /*
     Создание для каждого контроллера в данном примере выглядит оверхедом,
     но т.к. меню взято из реального проекта, то здесь тоже как в реальном проекте.
     А в реальности каждый пункт меню вызывает какую-то отдельную фичу приложения со своей навигацией.
     А если есть в приложении логические блоки разные которые не пересекаются между собой, то я их делю на разные сториборды.
     Так удобнее потом понимать навигацию приложения.
  */
    let storyBoard = UIStoryboard(name: "\(type.rawValue)", bundle: nil)
    guard let navigationVC = storyBoard.instantiateInitialViewController() as? UINavigationController else {
      return UINavigationController()
    }
    
    if let rootViewController = navigationVC.children.first as? UIViewController {
      rootViewController.navigationItem.leftBarButtonItem = menuController.menuButton
    }
    
    return navigationVC
  }
}
