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
        
        // Set in initial frame & in final frame & out final frame
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