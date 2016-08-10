//
//  CQPopupPresentation.swift
//  Pods
//
//  Created by Cunqi.X on 8/8/16.
//
//

import UIKit

/// Popup presentation manager
public final class PresentationManager: NSObject, UIViewControllerTransitioningDelegate {
  
  // MARK: Public
  
  public var animationAppearance: CQPopupAnimationAppearance
  
  // MARK: Private & Internal
  
  let backgroundColor: UIColor
  
  // MARK: Initializer
  
  /**
   Creates presentation manager
   
   - parameter animationAppearance: Animation appearance
   - parameter backgroundColor:     background color during transition
   
   - returns: presentation manager
   */
  public init(animationAppearance: CQPopupAnimationAppearance, backgroundColor: UIColor) {
    self.animationAppearance = animationAppearance
    self.backgroundColor = backgroundColor
  }
  
  public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    let controller = PresentationController(presentedViewController: presented, presentingViewController: presenting)
    controller.background.backgroundColor = backgroundColor
    return controller
  }
  
  public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return getAnimation(animationAppearance.transitionInDuration, status: .transitIn, direction: animationAppearance.transitionDirection, style: animationAppearance.transitionStyle)
  }
  
  public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return getAnimation(animationAppearance.transitionOutDuration, status: .transitOut, direction: animationAppearance.transitionDirection, style: animationAppearance.transitionStyle)
  }
  
  /**
   Create transition animation
   
   - parameter duration:  Transition duration
   - parameter status:    Transation status
   - parameter direction: Transition direction
   - parameter style:     Transition style
   
   - returns: Transition animation
   */
  func getAnimation(duration: NSTimeInterval, status: CQPopupAnimationStatus, direction: CQPopupTransitionDirection, style: CQPopupTransitionStyle) -> CQPopupAnimation {
    switch style {
    case .fade:
      return CQPopupFadeAnimation(duration: duration, status: status, direction: direction)
    case .bounce:
      return CQPopupBounceAniamtion(duration: duration, status: status, direction: direction)
    case .zoom:
      return CQPopupZoomAnimation(duration: duration, status: status, direction: direction)
    case .custom:
      return customPopupAnimation(duration, status: status, direction: direction)
    }
  }
  
  /**
   Create custom transition
   
   - Todo: Should open an API for custom
   
   - parameter duration:  Transition animation
   - parameter status:    Transition status
   - parameter direction: Transition direction
   
   - returns: Custom transition animation
   */
  func customPopupAnimation(duration: NSTimeInterval, status: CQPopupAnimationStatus, direction: CQPopupTransitionDirection) -> CQPopupAnimation {
    return CQPopupFadeAnimation(duration: duration, status: status, direction: direction)
  }
}

/// Presentation controller
public class PresentationController: UIPresentationController {
  
  // MARK: Private & Internal
  
  /// Background view for transiting
  var background: UIView = UIView()
  
  public override func presentationTransitionWillBegin() {
    background.translatesAutoresizingMaskIntoConstraints = false
    background.frame = containerView!.bounds
    containerView!.insertSubview(background, atIndex: 0)
    
    let alpha = background.alpha
    background.alpha = 0
    
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({context in
      self.background.alpha = alpha
      }, completion: nil)
  }
  
  public override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({context in
      self.background.alpha = 0.0
      }, completion: nil)
  }
}
