//
//  PopupPresentation.swift
//  Pods
//
//  Created by Cunqi.X on 8/8/16.
//
//

import UIKit

/// Popup presentation manager
public final class PopupPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
  
  // MARK: Public
  
  public var animationAppearance: PopupAnimationAppearance
  
  // MARK: Private & Internal
  
  let coverLayerView: UIView
  
  // MARK: Initializer
  
  /**
   Creates presentation manager
   
   - parameter animationAppearance: Animation appearance
   - parameter coverLayerView:     background cover layer view during transition
   
   - returns: presentation manager
   */
  public init(animationAppearance: PopupAnimationAppearance, coverLayerView: UIView = UIView()) {
    self.animationAppearance = animationAppearance
    self.coverLayerView = coverLayerView
  }
  
  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let controller = PresentationController(presentedViewController: presented, presenting: presenting)
    controller.coverLayerView = coverLayerView
    return controller
  }
  
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return getAnimation(animationAppearance.transitionInDuration, status: .transitIn, direction: animationAppearance.transitionDirection, style: animationAppearance.transitionStyle)
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
  func getAnimation(_ duration: TimeInterval, status: PopupAnimationStatus, direction: PopupTransitionDirection, style: PopupTransitionStyle) -> PopupAnimation {
    switch style {
    case .plain:
      return PopupPlainAnimation(duration: duration, status: status, direction: direction)
    case .fade:
      return PopupFadeAnimation(duration: duration, status: status, direction: direction)
    case .bounce:
      return PopupBounceAnimation(duration: duration, status: status, direction: direction)
    case .zoom:
      return PopupZoomAnimation(duration: duration, status: status, direction: direction)
    case .custom:
      return customPopupAnimation(duration, status: status, direction: direction)
    }
  }
  
  /**
   Create custom transition
   
   - Todo: Should open an API for custom animation
   
   - parameter duration:  Transition animation
   - parameter status:    Transition status
   - parameter direction: Transition direction
   
   - returns: Custom transition animation
   */
  func customPopupAnimation(_ duration: TimeInterval, status: PopupAnimationStatus, direction: PopupTransitionDirection) -> PopupAnimation {
    return PopupFadeAnimation(duration: duration, status: status, direction: direction)
  }
}

/// Presentation controller
public final class PresentationController: UIPresentationController {
  
  // MARK: Private & Internal
  
  /// A background cover layer rendering an obvious background during transiting
  public var coverLayerView: UIView!
  
  public override func presentationTransitionWillBegin() {
    coverLayerView.translatesAutoresizingMaskIntoConstraints = false
    containerView!.insertSubview(coverLayerView, at: 0)
    containerView!.bindFrom("H:|[cover]|", views: ["cover": coverLayerView])
    containerView!.bindFrom("V:|[cover]|", views: ["cover": coverLayerView])
    
    let alpha = coverLayerView.alpha
    coverLayerView.alpha = 0
    
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: {context in
      self.coverLayerView.alpha = alpha
      }, completion: nil)
  }
  
  public override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: {context in
      self.coverLayerView.alpha = 0.0
      }, completion: nil)
  }
}
