//
// Created by Cunqi.X on 8/6/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Popup presentation manager
public class CQPopupPresentationManager: UIPresentationController {
    
    // MARK: Private & Internal
    
    /// Animation factory
    var animationFactory = CQPopupAnimationFactory()
    
    /// Animation appearance
    var appearance: CQPopupAppearance!
    
    var factory: CQPopupAnimationFactory {
        get {
            self.animationFactory.appearance = self.appearance
            return self.animationFactory
        }
        set {
            self.animationFactory = newValue
        }
    }
    
    /// Background view for transiting
    private lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.appearance.popUpBackgroundColor
        return view
    }()
    
    public override func presentationTransitionWillBegin() {
        self.background.frame = self.containerView!.bounds
        self.containerView!.insertSubview(self.background, atIndex: 0)
        
        let alpha = self.background.alpha
        self.background.alpha = 0
        
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({context in
            self.background.alpha = alpha
        }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator()?.animateAlongsideTransition({context in
            self.background.alpha = 0.0
        }, completion: nil)
    }
}

/// Create Popup animation
public class CQPopupAnimationFactory: NSObject {
    /// animation appearance
    var appearance: CQPopupAppearance!
    
    /**
     get popup animation
     
     - parameter status: CQPopupAnimationStatus
     
     - returns: Popup animation
     */
    func getAnimation(status: CQPopupAnimationStatus) -> CQPopupAnimation {
        let duration = status == .In ? appearance.transitionInDuration : appearance.transitionOutDuration
        switch appearance.transitionStyle {
        case .Fade:
            return CQPopupFadeAnimation(duration: duration, status: status, direction: appearance.transitionDirection)
        case .Bounce:
            return CQPopupBounceAniamtion(duration: duration, status: status, direction: appearance.transitionDirection)
        case .Zoom:
            return CQPopupZoomAnimation(duration: duration, status: status, direction: appearance.transitionDirection)
        case .Custom:
            return self.customPopupAnimation(duration, status: status)
        }
    }
    
    func customPopupAnimation(duration: NSTimeInterval, status: CQPopupAnimationStatus) -> CQPopupAnimation {
        return CQPopupFadeAnimation(duration: duration, status: status, direction: appearance.transitionDirection)
    }
}

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
        self.transitionDuration = duration
        self.status = status
        self.direction = direction
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch self.status {
        case .In:
            self.popup = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! CQPopup
            self.another = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            
            if let container = transitionContext.containerView() {
                container.addSubview(self.popup.view)
            }
        case .Out:
            self.another = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            self.popup = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)  as! CQPopup
        }
        
        let bounds = UIScreen.mainScreen().bounds
        
        // Set in inital frame & in final frame & out final frame
        self.inFinalFrame = transitionContext.finalFrameForViewController(self.popup)
        switch self.direction {
        case .LeftToRight:
            self.inStartFrame = CGRectOffset(self.inFinalFrame, -bounds.width, 0)
            self.outFinalFrame = CGRectOffset(self.inFinalFrame, bounds.width, 0)
        case .RightToLeft:
            self.inStartFrame = CGRectOffset(self.inFinalFrame,  bounds.width, 0)
            self.outFinalFrame = CGRectOffset(self.inFinalFrame, -bounds.width, 0)
        case .TopToBottom:
            self.inStartFrame = CGRectOffset(self.inFinalFrame, 0, -bounds.height)
            self.outFinalFrame = CGRectOffset(self.inFinalFrame, 0, bounds.height)
        case .BottomToTop:
            self.inStartFrame = CGRectOffset(self.inFinalFrame, 0, bounds.height)
            self.outFinalFrame = CGRectOffset(self.inFinalFrame, 0, +bounds.height)
        case .Center:
            self.inStartFrame = self.inFinalFrame
            self.outFinalFrame = self.inFinalFrame
        }
    }
}

/// CQPopup fade animation
class CQPopupFadeAnimation: CQPopupAnimation {
    var alpha: CGFloat = 0.0
    
    override init(duration: NSTimeInterval, status: CQPopupAnimationStatus, direction: CQPopupTransitionDirection) {
        super.init(duration: duration, status: status, direction: direction)
    }
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(transitionContext)
        switch self.status {
        case .In:
            self.popup.view.frame = self.inStartFrame
            self.alpha = self.popup.view.alpha
            self.popup.view.alpha = 0
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveLinear, animations: {
                self.popup.view.alpha = self.alpha
                self.popup.view.frame = self.inFinalFrame
            }, completion: {finished in
                transitionContext.completeTransition(finished)
            })
        case .Out:
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
        switch self.status {
        case .In:
            self.popup.view.frame = self.inStartFrame
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
                self.popup.view.frame = self.inFinalFrame
                }, completion: {finished in
                    transitionContext.completeTransition(finished)
            })
        case .Out:
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
        switch self.status {
        case .In:
            self.popup.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations:  {
             self.popup.view.transform = CGAffineTransformIdentity
            }, completion: {finished in
                transitionContext.completeTransition(finished)
            })
        case .Out:
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseIn, animations: {
                self.popup.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.popup.view.alpha = 0
            }, completion: {finished in
                    transitionContext.completeTransition(finished)
            })
        }
    }
}