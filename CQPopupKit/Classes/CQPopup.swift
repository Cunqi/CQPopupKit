//
// Created by Cunqi.X on 8/4/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Typealias of popup action
public typealias PopupAction = ([NSObject: AnyObject]?) -> Void

/// Creates a custom popup container
public class CQPopup: UIViewController {
    
    // MARK: Public
    
    /// Custom popup appearance
    public var appearance = CQAppearance.appearance.popup
    
    /// Custom popup animation appearance
    public var animationAppearance: CQPopupAnimationAppearance {
        get {
            return self.presentationManager.animationAppearance
        }
        set {
            self.presentationManager.animationAppearance = newValue
        }
    }
    
    /// Negative action after popup returning with a negative status
    public internal(set) var negativeAction: PopupAction?

    /// Positive action after popup returning with a positive status
    public internal(set) var positiveAction: PopupAction?

    /// The view displayed on the container
    public private(set) var contentView: UIView?
    
    private var presentationManager: PresentationManager!

    // MARK: Private / Internal

    /// The negative action notification name used for notification posting
    private static let negativeActionNotification = "CQPopupNegative"

    /// The positive action notification name
    private static let positiveActionNotification = "CQPopupPositive"

    /// The fake background view used for receiving touche events ONLY!
    lazy var touchReceiverView: UIView = {

        let touchReceiverView = UIView.init()
        touchReceiverView.translatesAutoresizingMaskIntoConstraints = false
        if self.appearance.enableTouchOutsideToDismiss {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
            touchReceiverView.addGestureRecognizer(tapGesture)
        }
        return touchReceiverView
    }()

    /// The view for rendering container shadow ONLY!, it holds container as a subview
    lazy var shadowContainer: CQPopupContainer = {
        let shadowContainer = CQPopupContainer(containerType: .Shadow, appearance: self.appearance)
        shadowContainer.fillSubview(self.container)
        return shadowContainer
    }()

    /// The view contains content view
    lazy var container: CQPopupContainer = {
        let container = CQPopupContainer(containerType: .Plain, appearance: self.appearance)
        if let content = self.contentView {
            content.translatesAutoresizingMaskIntoConstraints = false
            container.fillSubview(content)
        }
        return container
    }()

    /// The horizontal position constraint of shadow container (aka. container, same below)
    var horizontalConst: NSLayoutConstraint!

    /// The vertical position constraint of shadow container
    var verticalConst: NSLayoutConstraint!

    /// The width constraint of shadow container
    var widthConst: NSLayoutConstraint!

    /// The height constraint of shadow container
    var heightConst: NSLayoutConstraint!


    // MARK: Initializers
    
    /**
     Creates a popup with blank container
     
     - returns: Popup with blank container
     */
    public convenience init() {
        self.init(contentView: UIView(), negativeAction: nil, positiveAction: nil)
    }
    
    /**
     Creates a popup view controller containing a custom view
     
     - parameter contentView:    Custom view to be displayed on popup container
     - parameter negativeAction: Negative action when popup returns with negative status (like canceled, failed etc.)
     - parameter positiveAction: Positive action when popup returns with positive status (like confirmed, selected etc.)
     
     - returns: Popup with custom view
     */
    public init(contentView: UIView?, negativeAction: PopupAction? = nil, positiveAction: PopupAction? = nil) {
        self.contentView = contentView
        self.negativeAction = negativeAction
        self.positiveAction = positiveAction
        
        super.init(nibName: nil, bundle: nil)
        
        // Define popup presentation style
        self.modalPresentationStyle = .Custom
        
        // Transition delegate
        self.presentationManager = PresentationManager(animationAppearance: CQAppearance.appearance.animation, backgroundColor: self.appearance.popUpBackgroundColor)
        self.transitioningDelegate = self.presentationManager
    }
    
    // Hide super class's designated initializer
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Init with coder not implemented
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: View Controller life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindConstraintsToContainer()
        self.subscribeNotifications()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //fix the issue of background view from PresentationManager will block the gesture
        self.view.insertSubview(self.touchReceiverView, belowSubview: self.shadowContainer)
        self.view.bindFrom("H:|[view]|", views: ["view": self.touchReceiverView]).bindFrom("V:|[view]|", views: ["view": self.touchReceiverView])
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.unsubscribeNotifications()
        self.positiveAction = nil
        self.negativeAction = nil
    }
    
    /**
     Bind constraints to shadow container
     */
    private func bindConstraintsToContainer() {
        self.view.addSubview(self.shadowContainer)
        self.bindHorizontalConstraint().bindVerticalConstraint().bindHeightConstraint().bindWidthConstraint()
        self.view.layoutIfNeeded()
    }

    /**
     Bind horizontal constraints to shadow container, based on **ViewAttachedPosition** value and **CQPopupAppearance.containerPadding**
     
     - returns: Popup view controller
     */
    private func bindHorizontalConstraint() -> CQPopup {
        let appearance = self.appearance
        switch appearance.viewAttachedPosition {
        case .Center:
            fallthrough
        case .Top:
            fallthrough
        case .Bottom:
            self.horizontalConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .CenterX)
        case .Left:
            self.horizontalConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .Leading, constant: appearance.containerPadding.left)
        case .Right:
            self.horizontalConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .Trailing, constant: -appearance.containerPadding.right)
        }
        self.view.addConstraint(self.horizontalConst)
        return self
    }
    
    /**
     Bind vertical constraints to shadow container, based on **ViewAttachedPosition** value and **CQPopupAppearance.containerPadding**
     
     - Remark: If your application is not in `full screen` mode, there will be a status bar on the top of the screen, the default height (20) will be added
     into the calculation of vertical position as the `constant` if you choose **ViewAttachedPosition.Top**.
     
     - Todo: Add a condition check before binding the vertical constraints, if app is full screen, default height should be 0, otherwise, 20.
     
     - returns: Popup view controller
     */
    private func bindVerticalConstraint() -> CQPopup {
        let defaultStatusBarHeight: CGFloat = 20
        let appearance = self.appearance
        switch appearance.viewAttachedPosition {
        case .Center:
            fallthrough
        case .Left:
            fallthrough
        case .Right:
            self.verticalConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .CenterY)
        case .Top:
            self.verticalConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .Top, constant: appearance.containerPadding.top + defaultStatusBarHeight)
        case .Bottom:
            self.verticalConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .Bottom, constant: -appearance.containerPadding.bottom)
        }
        self.view.addConstraint(self.verticalConst)
        return self
    }
    
    /**
     Bind width constraints to shadow container, based on **CQPopupAppearance.widthMultiplier**
     
     - returns: Popup view controller
     */
    private func bindWidthConstraint() -> CQPopup {
        self.widthConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .Width, multiplier: self.appearance.widthMultiplier)
        self.view.addConstraint(self.widthConst)
        return self
    }
    
    /**
     Bind height constraints to shadow container, based on **CQPopupAppearance.heightMultiplier**
     
     - returns: Popup view controller
     */
    private func bindHeightConstraint() -> CQPopup {
        self.heightConst = self.view.buildConstraintWith(self.shadowContainer, attribute: .Height, multiplier: self.appearance.heightMultiplier)
        self.view.addConstraint(heightConst)
        return self
    }
    
    /**
     Subscribe negative & positive action notifications
     */
    private func subscribeNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(cancelActionInvoked), name: CQPopup.negativeActionNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(confirmActionInvoked), name: CQPopup.positiveActionNotification, object: nil)
    }
    
    /**
     Unsubscribe negative & positive action notifications
     */
    private func unsubscribeNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: CQPopup.negativeActionNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: CQPopup.positiveActionNotification, object: nil)
    }
    
    /**
     Dismiss the popup when receive negative notification, negative action (if have) will be invoked first
     
     - parameter notification: Notification contains nothing
     */
    @objc private func cancelActionInvoked(notification: NSNotification?) {
        if let action = self.negativeAction {
            action(notification?.userInfo)
        }
        self.delay(0.15) {self.dismiss()}
    }
    
    /**
     Dismiss the popup when receive positive notification, positive action (if have) will be invoked first
     
     - parameter notification: Notification contains popUpInfo (if have)
     */
    @objc private func confirmActionInvoked(notification: NSNotification) {
        if let action = self.positiveAction {
            action(notification.userInfo)
        }
        self.delay(0.15) {self.dismiss()}
    }
    
    /**
     Dismiss the popup when outside of the container is tapped, negative action (if have) will be invoked first
     */
    @objc private func tapToDismiss() {
        self.cancelActionInvoked(nil)
    }
    
    /**
     Dismiss the popup
     */
    public func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /**
     Convenient method to send positive notification to popup
     
     - parameter popUpInfo: Info passing to positive action when popup returns
     */
    public static func sendPopupPositive(popUpInfo: [NSObject: AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(positiveActionNotification, object: nil, userInfo: popUpInfo)
    }

    /**
     Convenient method to send negative notification to popup
     
     - parameter popUpInfo: Info passing to negative action when popup returns
     */
    public static func sendPopupNegative(popUpInfo: [NSObject: AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(negativeActionNotification, object: nil, userInfo: popUpInfo)
    }
}