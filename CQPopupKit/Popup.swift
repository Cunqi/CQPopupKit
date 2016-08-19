//
// Created by Cunqi.X on 8/4/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Typealias of popup action
public typealias PopupAction = (AnyObject?) -> Void

/// Creates a custom popup container
public class Popup: UIViewController {
  
  // MARK: Public
  
  /// Custom popup appearance
  public var appearance = CQAppearance.appearance.popup
  
  /// Custom popup animation appearance
  public var animationAppearance: PopupAnimationAppearance {
    get {
      return presentationManager.animationAppearance
    }
    set {
      presentationManager.animationAppearance = newValue
    }
  }
  
  /// Negative action after popup returning with a negative status
  public internal(set) var negativeAction: PopupAction?
  
  /// Positive action after popup returning with a positive status
  public internal(set) var positiveAction: PopupAction?
  
  // MARK: Private / Internal
  
  private var presentationManager: PopupPresentationManager!
  
  /// The fake background view used for receiving touche events ONLY!
  lazy var touchReceiverView: UIView = {
    
    let touchReceiverView = UIView()
    touchReceiverView.translatesAutoresizingMaskIntoConstraints = false
    if self.appearance.enableTouchOutsideToDismiss {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
      touchReceiverView.addGestureRecognizer(tapGesture)
    }
    return touchReceiverView
  }()
  
  /// The view for rendering container shadow ONLY!, it holds container as a subview
  lazy var shadowContainer: PopupContainer = {
    let shadowContainer = PopupContainer(containerType: .shadow, appearance: self.appearance)
    return shadowContainer
  }()
  
  /// The view contains content view
  lazy var container: PopupContainer = {
    let container = PopupContainer(containerType: .plain, appearance: self.appearance)
    return container
  }()
  
  /// The view displayed on the container
  var contentView: UIView?
  
  // Todo: Will expose those constraints for dynamic changes, like updating a custom view with textField's position
  
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
   
   - returns: Popup with empty container
   */
  public convenience init() {
    self.init(contentView: UIView(), positiveAction: nil, negativeAction: nil)
  }
  
  /**
   Creates a popup view controller containing a custom view
   
   - parameter contentView:    Custom view to be displayed on popup container
   - parameter positiveAction: Positive action when popup returns with positive status (like confirmed, selected etc.)
   - parameter negativeAction: Negative action when popup returns with negative status (like canceled, failed etc.)
   
   - returns: Popup with custom view
   */
  public init(contentView: UIView?, positiveAction: PopupAction? = nil, negativeAction: PopupAction? = nil) {
    self.contentView = contentView
    self.negativeAction = negativeAction
    self.positiveAction = positiveAction
    
    super.init(nibName: nil, bundle: nil)
    
    shadowContainer.fillWithSubview(self.container)
    installContentView()
    
    // Define popup presentation style
    modalPresentationStyle = .Custom
    
    // Transition delegate
    presentationManager = PopupPresentationManager(animationAppearance: CQAppearance.appearance.animation)
    presentationManager.coverLayerView.backgroundColor = appearance.popUpBackgroundColor
    transitioningDelegate = presentationManager
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
    bindConstraintsToContainer()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //fix the issue of background view from PopupPresentationManager will block the gesture
    view.insertSubview(touchReceiverView, belowSubview: shadowContainer)
    view.bindFrom("H:|[view]|", views: ["view": touchReceiverView])
    view.bindFrom("V:|[view]|", views: ["view": touchReceiverView])
  }
  
  public override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    positiveAction = nil
    negativeAction = nil
  }
  
  /// Support orientation changed
  /// if fixed width / height is set, ignore popupWidth / popupHeight
  public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    let width = appearance.fixedWidth == 0 ? appearance.popupWidth : appearance.fixedWidth
    let height = appearance.fixedHeight == 0 ? appearance.popupHeight : appearance.fixedHeight
    let newWidthMultiplier = width / size.width
    let newHeightMultiplier = height / size.height
    
    if newWidthMultiplier <= 1.0 {appearance.widthMultiplier = newWidthMultiplier}
    if newHeightMultiplier <= 1.0 {appearance.heightMultiplier = newHeightMultiplier}
    
    //update width & height constraints
    view.removeConstraints([widthConst, heightConst])
    bindHeightConstraint()
    bindWidthConstraint()
  }
  
  /**
   install content view to container
   */
  func installContentView() {
    if let content = self.contentView {
      content.translatesAutoresizingMaskIntoConstraints = false
      container.fillWithSubview(content)
    }
  }
  
  /**
   Bind constraints to shadow container
   */
  private func bindConstraintsToContainer() {
    view.addSubview(shadowContainer)
    bindHorizontalConstraint()
    bindVerticalConstraint()
    bindHeightConstraint()
    bindWidthConstraint()
    view.layoutIfNeeded()
  }
  
  /**
   Bind horizontal constraints to shadow container, based on **ViewAttachedPosition** value and **PopupAppearance.containerPadding**
   
   - returns: Popup view controller
   */
  private func bindHorizontalConstraint() {
    switch appearance.viewAttachedPosition {
    case .center:
      fallthrough
    case .top:
      fallthrough
    case .bottom:
      horizontalConst = view.buildConstraintWith(shadowContainer, attribute: .CenterX)
    case .left:
      horizontalConst = view.buildConstraintWith(shadowContainer, attribute: .Leading, constant: appearance.containerPadding.left)
    case .right:
      horizontalConst = view.buildConstraintWith(shadowContainer, attribute: .Trailing, constant: -appearance.containerPadding.right)
    }
    view.addConstraint(horizontalConst)
  }
  
  /**
   Bind vertical constraints to shadow container, based on **ViewAttachedPosition** value and **PopupAppearance.containerPadding**
   
   - Remark: If your application is not in `full screen` mode, there will be a status bar on the top of the screen, the default height (20) will be added
   into the calculation of vertical position as the `constant` if you choose **ViewAttachedPosition.Top**.
   
   - Todo: Add a condition check before binding the vertical constraints, if app is full screen, default height should be 0, otherwise, 20.
   
   - returns: Popup view controller
   */
  private func bindVerticalConstraint() {
    let defaultStatusBarHeight: CGFloat = 20
    switch appearance.viewAttachedPosition {
    case .center:
      fallthrough
    case .left:
      fallthrough
    case .right:
      verticalConst = view.buildConstraintWith(shadowContainer, attribute: .CenterY)
    case .top:
      verticalConst = view.buildConstraintWith(shadowContainer, attribute: .Top, constant: appearance.containerPadding.top + defaultStatusBarHeight)
    case .bottom:
      verticalConst = view.buildConstraintWith(shadowContainer, attribute: .Bottom, constant: -appearance.containerPadding.bottom)
    }
    view.addConstraint(verticalConst)
  }
  
  /**
   Bind width constraints to shadow container, based on **PopupAppearance.widthMultiplier**
   
   - returns: Popup view controller
   */
  private func bindWidthConstraint() {
    widthConst = view.buildConstraintWith(shadowContainer, attribute: .Width, multiplier: appearance.widthMultiplier)
    view.addConstraint(widthConst)
  }
  
  /**
   Bind height constraints to shadow container, based on **PopupAppearance.heightMultiplier**
   
   - returns: Popup view controller
   */
  private func bindHeightConstraint() {
    heightConst = view.buildConstraintWith(shadowContainer, attribute: .Height, multiplier: appearance.heightMultiplier)
    view.addConstraint(heightConst)
  }
  
  /**
   Dismiss the popup when invoked, negative action (if have) will be invoked first
   
   - parameter popupInfo: popup info passed to negative action
   */
  public func invokeNegativeAction(popupInfo: AnyObject?) {
    if let action = negativeAction {
      action(popupInfo)
    }
    delay(0.15) {self.dismiss()}
  }
  
  /**
   Dismiss the popup when invoked, positive action (if have) will be invoked first
   
   - parameter popupInfo: popup info passed to positive action
   */
  public func invokePositiveAction(popupInfo: AnyObject?) {
    if let action = positiveAction {
      action(popupInfo)
    }
    delay(0.15) {self.dismiss()}
  }
  
  /**
   Dismiss the popup when outside of the container is tapped, negative action (if have) will be invoked first
   */
  func tapToDismiss() {
    invokeNegativeAction(nil)
  }
  
  /**
   Dismiss the popup
   */
  public func dismiss() {
    dismissViewControllerAnimated(true, completion: nil)
  }
}