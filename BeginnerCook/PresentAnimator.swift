//
//  PresentAnimator.swift
//  BeginnerCook
//
//  Created by Marin Todorov on 11/13/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//
//  modified by Dave Rothschild May 5, 2016

import UIKit

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration = 1.0
  
    // frame of where the image was. Animate from this point
  var originFrame = CGRect.zero
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    //1) setup the transition
    let containerView = transitionContext.containerView()!
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    
    //2) create animation
    let finalFrame = toView.frame
    
    let xScaleFactor = originFrame.width / finalFrame.width
    let yScaleFactor = originFrame.height / finalFrame.height
    
    let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
    
    toView.transform = scaleTransform
    toView.center = CGPoint(
      x: CGRectGetMidX(originFrame),
      y: CGRectGetMidY(originFrame)
    )
    toView.clipsToBounds = true
    
    containerView.addSubview(toView)
    
    let herbController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! HerbDetailsViewController
    herbController.containerView.alpha = 0
    // start the animation
    UIView.animateWithDuration(duration, delay: 0.0,
      usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
      options: [], animations: {
      
        toView.transform = CGAffineTransformIdentity
        toView.center = CGPoint(
          x: CGRectGetMidX(finalFrame),
          y: CGRectGetMidY(finalFrame)
        )
        herbController.containerView.alpha = 1.0
      
      }, completion: {_ in
    
        //3 complete the transition
        transitionContext.completeTransition(
          !transitionContext.transitionWasCancelled()
        )
    })
   
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = 20.0/xScaleFactor
    round.toValue = 0.0
    round.duration = duration / 2
    toView.layer.addAnimation(round, forKey: nil)
    toView.layer.cornerRadius = 0.0
    
  }
  
}
