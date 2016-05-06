//
//  DismissAnimator.swift
//  BeginnerCook
//
//  Created by Marin Todorov on 11/13/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//
//
//  modified by Dave Rothschild May 5, 2016

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration = 1.0
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    //1) setup the transition
    let containerView = transitionContext.containerView()!
    
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    
    containerView.insertSubview(toView, belowSubview: fromView)
    
    //2) animations!
    UIView.animateWithDuration(duration/2, delay: 0.0,
      usingSpringWithDamping: 0.5, initialSpringVelocity: 0,
      options: [], animations: {
      
      fromView.transform = CGAffineTransformMakeScale(0.5, 0.5)
      
      }, completion: nil)
    
    UIView.animateWithDuration(duration/2, delay: duration/2, options: [], animations: {
      
      fromView.center.x += containerView.frame.size.width
      
      }, completion: {_ in
    
        //3) complete the transition
        transitionContext.completeTransition(
          !transitionContext.transitionWasCancelled()
        )
    })
    
    let background = UIView(frame: containerView.bounds)
    background.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
    containerView.insertSubview(background, belowSubview: fromView)

    UIView.animateWithDuration(duration, delay: 0.0, options: [], animations: {
      background.alpha = 0
      }, completion: {_ in
        background.removeFromSuperview()
    })
  }
  
}
