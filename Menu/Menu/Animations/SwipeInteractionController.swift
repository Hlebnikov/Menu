//
//  SwipeInteractionController.swift
//  VekaMeasurer
//
//  Created by Aleksandr X on 04.10.17.
//  Copyright © 2017 IceRock Development. All rights reserved.
//

import UIKit

class SwipeMenuInteractionController: UIPercentDrivenInteractiveTransition {
  var interactionInProgress = false
  private var shouldCompleteTransition = false
  
  private weak var menuController: MenuController!
  private weak var menuViewController: UIViewController!
  private weak var backView: UIView?
  
  func wireToController(_ menuController: MenuController) {
    self.menuController = menuController
    prepareGestureRecognizerInView(view: menuController.menuContainer.view)
  }
  
  func wireToBack(view: UIView) {
    self.menuViewController = menuController.menuViewController
    
    self.backView = view
    prepareBackGestureInView(view: backView!)
  }
  
  private func prepareGestureRecognizerInView(view: UIView) {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
    gesture.edges = UIRectEdge.left
    view.addGestureRecognizer(gesture)
  }
  
  private func prepareBackGestureInView(view: UIView) {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
    gesture.edges = UIRectEdge.right
    view.addGestureRecognizer(gesture)
    
    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
    view.addGestureRecognizer(tapgesture)
  }

  @objc
  func handleGesture(gestureRecognizer: UIGestureRecognizer) {
    if gestureRecognizer is UITapGestureRecognizer {
      menuController.closeMenu()
      return
    }
    
    guard let gestureRecognizer = gestureRecognizer as? UIScreenEdgePanGestureRecognizer else {
      return
    }
    
    let isClosingAction = gestureRecognizer.edges == .right
    let translation = gestureRecognizer.translation(in: UIApplication.shared.keyWindow!)
    var progress: CGFloat = 0.0
    progress = (isClosingAction ? -1 : 1) * translation.x / UIScreen.main.bounds.width
    
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
    
    print("\(translation.x) - \(progress)")
    switch gestureRecognizer.state {
    case .began:
      interactionInProgress = true
      if isClosingAction {
        menuController.closeMenu()
      } else {
        menuController.openMenu()
      }
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      if !shouldCompleteTransition {
        cancel()
        if !isClosingAction {
          if let backView = self.backView {
            let window = UIApplication.shared.keyWindow!
            window.bringSubviewToFront(backView)
          }
        }
      } else {
        finish()
        if isClosingAction {
          backView?.removeFromSuperview()
        }
      }
    default:
      break
    }
  }
}
