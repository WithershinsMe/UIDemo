//
//  CenterViewFlowLayout.swift
//  Demo
//
//  Created by GK on 2018/6/23.
//  Copyright © 2018年 GK. All rights reserved.
//
import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let originFrame: CGRect
  private let finalFrame: CGRect?

  var dismissCompletion: (()->Void)?
  var originView: UIView?
  let snapshotView: UIView?

    init(originFrame: CGRect,finalFrame:CGRect?, snapshotView: UIView?) {
    self.originFrame = originFrame
    self.finalFrame = finalFrame
    self.snapshotView = snapshotView
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let toVC = transitionContext.viewController(forKey: .to),
      let tmpsnapshot = toVC.view.snapshotView(afterScreenUpdates: true)
      else {
        return
    }
    
    var snapshot = tmpsnapshot
    if let tmp = self.snapshotView {
        snapshot = tmp.snapshotView(afterScreenUpdates: true)!
    }
    
    originView?.isHidden = true
    let containerView = transitionContext.containerView
    let finalFrame = self.finalFrame ?? transitionContext.finalFrame(for: toVC)
    
    snapshot.frame = originFrame
    snapshot.layer.cornerRadius = 5
    snapshot.layer.masksToBounds = true
    
    containerView.insertSubview(toVC.view, at: 0)
    containerView.addSubview(snapshot)
    toVC.view.isHidden = true
    
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
      snapshot.frame = finalFrame
    }) { _ in
      toVC.view.isHidden = false
      snapshot.removeFromSuperview()
      if (self.dismissCompletion != nil) {
        self.dismissCompletion?()
      }
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }

  }
}
