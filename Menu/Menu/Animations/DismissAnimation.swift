//
//  DismissAnimation.swift
//  TransitionAnimation
//
//  Created by Aleksandr X on 01.10.17.
//  Copyright © 2017 Khlebnikov. All rights reserved.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  private let duaration: TimeInterval = 0.3
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duaration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toVC = transitionContext.viewController(forKey: .to)!
    
    let window = UIApplication.shared.keyWindow!
    let snapshot = window.subviews.first(where: { $0.accessibilityIdentifier == "snapshot" })!

    toVC.view.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    toVC.view.transform = CGAffineTransform.identity
    toVC.view.layer.shadowOpacity = 0
    toVC.view.isHidden = false
    
    transitionContext.containerView.sendSubviewToBack(toVC.view)
    
    // для исправления багов навбара в iOS 11 анимируем не сам контроллер, а его скриншот
    if let newSnapshot = toVC.view.snapshotView(afterScreenUpdates: true) {
      newSnapshot.transform = snapshot.transform
      newSnapshot.frame = snapshot.bounds
      
      // так же скриншот позволяет нам сделать красивое скругление для безрамочных айфонов
      if isIPhoneXOrHigher {
        newSnapshot.layer.cornerRadius = 40
        newSnapshot.clipsToBounds = true
      }
      
      snapshot.addSubview(newSnapshot)
    }
    
    UIView.animate(withDuration: duaration, animations: {
      snapshot.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
      snapshot.transform = CGAffineTransform.identity
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      if transitionContext.transitionWasCancelled {

      } else {
        transitionContext.containerView.bringSubviewToFront(toVC.view)
        snapshot.removeFromSuperview()
      }
    })
  }
  
  private var isIPhoneXOrHigher: Bool {
    return UIDevice().userInterfaceIdiom == .phone && UIScreen.main.bounds.height >= 812
  }
}
