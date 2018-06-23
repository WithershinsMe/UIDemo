//
//  CenterViewFlowLayout.swift
//  Demo
//
//  Created by GK on 2018/6/23.
//  Copyright © 2018年 GK. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let destinationFrame: CGRect
  var dismissCompletion: (()->Void)?

  let snapshotView: UIView?
  
  init(destinationFrame: CGRect,snapshotView: UIView?) {
    self.destinationFrame = destinationFrame
    self.snapshotView = snapshotView
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to)
      else{
        return
    }
    let snapshotView: UIView;

    if self.snapshotView != nil {
      snapshotView = self.snapshotView!
    }else {
      snapshotView = fromVC.view
    }
    
    guard  let snapshot = snapshotView.snapshotView(afterScreenUpdates: true) else {
      return
    }
   
    snapshot.layer.cornerRadius = 5
    snapshot.layer.masksToBounds = true
    
    let containerView = transitionContext.containerView
    containerView.insertSubview(toVC.view, at: 0)
    containerView.addSubview(snapshot)
    fromVC.view.isHidden = true
    
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
      snapshot.frame = self.destinationFrame
    }) { _ in
      toVC.view.isHidden = false
      snapshot.removeFromSuperview()
      if transitionContext.transitionWasCancelled {
            toVC.view.removeFromSuperview()
      }
      self.dismissCompletion?()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}
