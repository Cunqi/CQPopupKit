//
// Created by Cunqi.X on 8/6/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Root of all popup animation
class PopupAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  
  // MARK: Private & Internal
  
  let transitionDuration: TimeInterval
  let status: PopupAnimationStatus
  let direction: PopupTransitionDirection
  
  /// initial frame of popup view before transition in animation
  var inStartFrame: CGRect!
  
  /// final frame of popup view after transition in animation
  var inFinalFrame: CGRect!
  
  /// final frame of popup view after transition out animation
  var outFinalFrame: CGRect!
  
  /// two views which participates in the transition
  var popup: Popup!
  var another: UIViewController!
  
  // MARK: Initializer
  
  /**
   Creates popup animation
   
   - parameter duration:  Transition duration
   - parameter status:    Transition animation status
   - parameter direction: Transition direction
   
   - returns: Popup animation
   */
  init(duration: TimeInterval, status: PopupAnimationStatus, direction: PopupTransitionDirection) {
    transitionDuration = duration
    self.status = status
    self.direction = direction
    super.init()
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return transitionDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch status {
    case .transitIn:
      popup = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as! Popup
      another = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)
      transitionContext.containerView.addSubview(popup.view)
    case .transitOut:
      another = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)
      popup = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)  as! Popup
    }

    let bounds = UIScreen.main.bounds
    
    // Set in initial frame & in final frame & out final frame
    inFinalFrame = transitionContext.finalFrame(for: popup)
    switch direction {
    case .leftToRight:
      inStartFrame = inFinalFrame.offsetBy(dx: -bounds.width, dy: 0)
      outFinalFrame = inFinalFrame.offsetBy(dx: bounds.width, dy: 0)
    case .rightToLeft:
      inStartFrame = inFinalFrame.offsetBy(dx: bounds.width, dy: 0)
      outFinalFrame = inFinalFrame.offsetBy(dx: -bounds.width, dy: 0)
    case .topToBottom:
      inStartFrame = inFinalFrame.offsetBy(dx: 0, dy: -bounds.height)
      outFinalFrame = inFinalFrame.offsetBy(dx: 0, dy: bounds.height)
    case .bottomToTop:
      inStartFrame = inFinalFrame.offsetBy(dx: 0, dy: bounds.height)
      outFinalFrame = inFinalFrame.offsetBy(dx: 0, dy: +bounds.height)
    case .center:
      inStartFrame = inFinalFrame
      outFinalFrame = inFinalFrame
    }
  }
}

/// Popup plain animation
class PopupPlainAnimation: PopupAnimation {
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(using: transitionContext)
    switch status {
    case .transitIn:
      popup.view.frame = inStartFrame
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
        self.popup.view.frame = self.inFinalFrame
      }, completion: {finished in
        transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
        self.popup.view.frame = self.outFinalFrame
      }, completion: {finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}

/// Popup fade animation
class PopupFadeAnimation: PopupAnimation {
  var alpha: CGFloat = 0
  
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(using: transitionContext)
    switch status {
    case .transitIn:
      popup.view.frame = inStartFrame
      alpha = popup.view.alpha
      popup.view.alpha = 0
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
        self.popup.view.alpha = self.alpha
        self.popup.view.frame = self.inFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
        self.popup.view.alpha = 0
        self.popup.view.frame = self.outFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    }
  }
}

/// Popup bounce animation
class PopupBounceAnimation: PopupAnimation {
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(using: transitionContext)
    switch status {
    case .transitIn:
      popup.view.frame = inStartFrame
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
        self.popup.view.frame = self.inFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn, animations: {
        self.popup.view.frame = self.outFinalFrame
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    }
  }
  
}

/// Popup zoom animation
class PopupZoomAnimation: PopupAnimation {
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    super.animateTransition(using: transitionContext)
    switch status {
    case .transitIn:
      popup.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations:  {
        self.popup.view.transform = CGAffineTransform.identity
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    case .transitOut:
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn, animations: {
        self.popup.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.popup.view.alpha = 0
        }, completion: {finished in
          transitionContext.completeTransition(finished)
      })
    }
  }
}
