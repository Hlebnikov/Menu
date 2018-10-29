//
//  PopAnimation.swift
//  TransitionAnimation
//
//  Created by Aleksandr X on 30.09.17.
//  Copyright © 2017 Khlebnikov. All rights reserved.
//

import UIKit

class SlideAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  private let duration: TimeInterval = 0.3
  private let distance: CGFloat = 80
  private let scale: CGFloat = 0.85
  private let shadowRadius: CGFloat = 25
  private let shadowOpasity: Float = 0.5
  
  var onComplete: ((_ snapshot: UIView) -> Void)?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toVC = transitionContext.viewController(forKey: .to)!
    let fromVC = transitionContext.viewController(forKey: .from)!
    let window = UIApplication.shared.keyWindow!

    toVC.view.frame = CGRect(x: 0, y: 0, width: fromVC.view.bounds.width, height: fromVC.view.bounds.height)
    toVC.view.center = fromVC.view.center
    
    let snapshot = snapshotView(from: fromVC.view)
    window.addSubview(snapshot)
    
    transitionContext.containerView.addSubview(toVC.view)
    transitionContext.containerView.sendSubviewToBack(toVC.view)
    window.bringSubviewToFront(snapshot)
    let center = fromVC.view.center
    
    fromVC.view.isHidden = true
    fromVC.navigationController?.isNavigationBarHidden = true
    let transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
    let newCenter = CGPoint(x: center.x + fromVC.view.bounds.width - self.distance, y: center.y)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
      snapshot.center = newCenter
      snapshot.transform = transform
      snapshot.layer.shadowOpacity = self.shadowOpasity
      snapshot.layer.shadowRadius = self.shadowRadius
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      if transitionContext.transitionWasCancelled {
        fromVC.view.isHidden = false
        snapshot.removeFromSuperview()
      } else {
        self.onComplete?(snapshot)
        window.bringSubviewToFront(snapshot)
        fromVC.view.transform = transform
        fromVC.view.center = newCenter
      }
    })
  }
  
  private func snapshotView(from view: UIView) -> UIView {
    let snapshot = view.snapshotView(afterScreenUpdates: false)!
    snapshot.frame = UIScreen.main.bounds
    let snapshotView = UIView(frame: snapshot.bounds)
    
    let shadowView = UIView(frame: snapshot.frame)
    shadowView.backgroundColor = .white
    
    snapshotView.addSubview(shadowView)
    snapshotView.addSubview(snapshot)
    
    if isIPhoneXOrHigher {
      snapshot.layer.cornerRadius = 40
      shadowView.layer.cornerRadius = 40
      snapshot.clipsToBounds = true
    }
    
    snapshotView.accessibilityIdentifier = "snapshot" // теперь ее всегда можно найти по этому идентификатору если она есть. Используется в анимации возврата
    return snapshotView
  }
  
  private var isIPhoneXOrHigher: Bool {
    return UIDevice().userInterfaceIdiom == .phone && UIScreen.main.bounds.height >= 812
  }
}
