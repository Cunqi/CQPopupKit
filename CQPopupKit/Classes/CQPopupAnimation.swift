//
// Created by Cunqi.X on 8/6/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Root of all popup animation
class CQPopupAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  
  // MARK: Private & Internal
  
  let transitionDuration: NSTimeInterval
  let status: CQPopupAnimationStatus
  let direction: CQPopupTransitionDirection
  
  /// initial frame of popup view before transition in animation
  var inStartFrame: CGRect!
  
  /// final frame of popup view after transition in animation
  var inFinalFrame: CGRect!
  
  /// final frame of popup view after transition out animation
  var outFinalFrame: CGRect!
  
  /// two views which participates in the transition
  var popup: CQPopup!
  var another: UIViewController!
  
  // MARK: Initializer
  
  /**
   Creates popup animation
   
   - parameter duration:  Transition duration
   - parameter status:    Transition animation status
   - parameter direction: Transition direction
   
   - returns: Popup animation
   */
  init(duration: NSTimeInterval, status: CQPopupAnimationStatus, direction: CQPopupTransitionDirection) {
    transitionDuration = duration
    self.status = status
    self.direction = direction
    super.init()
  }
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return transitionDuration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    switch status {
    case .transitIn:
      popup = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! CQPopup
      another = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
      
      if let container = transitionContext.containerView() {
        container.addSubview(popup.view)
      }
    case .transitOut:
      another = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
      popup = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)  as! CQPopup
    }
    
    let bounds = UIScreen.mainScreen().bounds
    
    // Set in initial frame & in final frame & out final frame
    inFinalFrame = transitionContext.finalFrameForViewController(popup)
    switch direction {
    case .leftToRight:
      inStartFrame = CGRectOffset(inFinalFrame, -bounds.width, 0)
      outFinalFrame = CGRectOffset(inFinalFrame, bounds.width, 0)
    case .rightToLeft:
      inStartFrame = CGRectOffset(inFinalFrame,  bounds.width, 0)
      outFinalFrame = CGRectOffset(inFinalFrame, -bounds.width, 0)
    case .topToBottom:
      inStartFrame = CGRectOffset(inFinalFrame, 0, -bounds.height)
      outFinalFrame = CGRectOffset(inFinalFrame, 0, bounds.height)
    case .bottomToTop:
      inStartFrame = CGRectOffset(inFinalFrame, 0, bounds.height)
      outFinalFrame = CGRectOffset(inFinalFrame, 0, +bounds.height)
    case .center:
      inStartFrame = inFinalFrame
      outFinalFrame = inFinalFrame
    }
  }
}

/// CQPopup plain animation
class CQPopupPlainAnimation: CQPopupAnimation {
  override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(transitionContext)
    switch status {
    case .transitIn:
      popup.view.frame = inStartFrame
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveLinear, animations: {
        self.popup.view.frame = self.inFinalFrame
      }, completion: {finished in
        transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveLinear, animations: {
        self.popup.view.frame = self.outFinalFrame
      }, completion: {finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}

/// CQPopup fade animation
class CQPopupFadeAnimation: CQPopupAnimation {
  var alpha: CGFloat = 0
  
  override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(transitionContext)
    switch status {
    case .transitIn:
      popup.view.frame = inStartFrame
      alpha = popup.view.alpha
      popup.view.alpha = 0
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveLinear, animations: {
        self.popup.view.alpha = self.alpha
        self.popup.view.frame = self.inFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveLinear, animations: {
        self.popup.view.alpha = 0
        self.popup.view.frame = self.outFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    }
  }
}

class CQPopupBounceAniamtion: CQPopupAnimation {
  override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(transitionContext)
    switch status {
    case .transitIn:
      popup.view.frame = inStartFrame
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
        self.popup.view.frame = self.inFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseIn, animations: {
        self.popup.view.frame = self.outFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    }
  }
  
}

class CQPopupZoomAnimation: CQPopupAnimation {
  override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(transitionContext)
    switch status {
    case .transitIn:
      popup.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations:  {
        self.popup.view.transform = CGAffineTransformIdentity
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseIn, animations: {
        self.popup.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.popup.view.alpha = 0
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    }
  }
}