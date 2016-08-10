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
  
  let canvasLayer: UIView
  
  // MARK: Initializer
  
  /**
   Creates presentation manager
   
   - parameter animationAppearance: Animation appearance
   - parameter coverLayer:     background cover layer during transition
   
   - returns: presentation manager
   */
  public init(animationAppearance: CQPopupAnimationAppearance, canvasLayer: UIView = UIView()) {
    self.animationAppearance = animationAppearance
    self.canvasLayer = canvasLayer
  }
  
  public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    let controller = PresentationController(presentedViewController: presented, presentingViewController: presenting)
    controller.coverLayer = canvasLayer
    controller.shouldFade = animationAppearance.transitionStyle == .fade
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
   - parameter status:    Transition status
   - parameter direction: Transition direction
   - parameter style:     Transition style
   
   - returns: Transition animation
   */
  func getAnimation(duration: NSTimeInterval, status: CQPopupAnimationStatus, direction: CQPopupTransitionDirection, style: CQPopupTransitionStyle) -> CQPopupAnimation {
    switch style {
    case .plain:
      return CQPopupPlainAnimation(duration: duration, status: status, direction: direction)
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
  
  /// A background cover layer rendering an obvious background during transiting
  public var coverLayer: UIView!

  public var shouldFade: Bool = false
  
  public override func presentationTransitionWillBegin() {
    coverLayer.translatesAutoresizingMaskIntoConstraints = false
    coverLayer.frame = containerView!.bounds
    containerView!.insertSubview(coverLayer, atIndex: 0)
    
    let alpha = coverLayer.alpha
    if shouldFade {coverLayer.alpha = 0}
    
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({context in
      self.coverLayer.alpha = alpha
      }, completion: nil)
  }
  
  public override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({context in
      if self.shouldFade {self.coverLayer.alpha = 0.0}
      }, completion: nil)
  }
}
