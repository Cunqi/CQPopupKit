//
//  PopupAppearance.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/5/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/**
 The position of containers
 
 - center: The container has CenterX and CenterY equivalent with parent(aka. CQPopup.view)
 - left:   The container has CenterY and Leading equivalent with parent(aka. CQPopup.view)
 - right:  The container has CenterY and Trailing equivalent with parent(aka. CQPopup.view)
 - top:    The container has CenterX and Top equivalent with parent(aka. CQPopup.view)
 - bottom: The container has CenterX and Bottom1980 equivalent with parent(aka. CQPopup.view)
 */
public enum AttachedPosition: Int {
  case center = 0
  case left = 1
  case right = 2
  case top = 3
  case bottom = 4
}

/**
 Popup transition animation style

 - plain:  Move without fade effect
 - zoom:   Zoom in and zoom out (Center direction ONLY)
 - fade:   Fade in and fade out
 - bounce: Bounce in and bounce out
 - custom: Custom implementation
 */
public enum PopupTransitionStyle: Int {
  case plain = 0
  case zoom = 1
  case fade = 2
  case bounce = 3
  case custom = 4
}

/**
 Popup transition animation direction
 
 - leftToRight: From left to right
 - rightToLeft: From right to left
 - topToBottom: From top to bottom
 - bottomToTop: From bottom to top
 - center:      Stay at center (For Zoom / Custom transition style ONLY!)
 */
public enum PopupTransitionDirection: Int {
  case leftToRight = 0
  case rightToLeft = 1
  case topToBottom = 2
  case bottomToTop = 3
  case center = 4
  case leftReverse = 5
  case rightReverse = 6
}

/**
 Current animation status of transition in / transition out
 
 - transitIn:  Transition in
 - transitOut: Transition out
 */
public enum PopupAnimationStatus: Int {
  case transitIn = 0
  case transitOut = 1
}

/// CQPopupKit global appearance
open class CQAppearance: NSObject {
  open static let appearance = CQAppearance()

  /// Popup basic appearance
  open var popup = PopupAppearance()

  /// Popup animation appearance
  open var animation = PopupAnimationAppearance()

  /// Popup alert controller (alertView & actionSheet) appearance
  open lazy var alert: PopupAlertControllerAppearance = {
    return PopupAlertControllerAppearance()
  }()
  
  open lazy var dialogue: PopupDialogueAppearance = {
    return PopupDialogueAppearance()
  }()

  // MARK: Initializer

  /// For global appearance only
  fileprivate override init(){}
}

/**
 *  Popup basic appearance
 */
public struct PopupAppearance {
  
  /// Background color of pop up
  public var popUpBackgroundColor = UIColor(white: 0, alpha: 0.5)
  
  /// If true tap outside of the container will dismiss the popup, otherwise false, default is `true`
  public var enableTouchOutsideToDismiss: Bool = true
  
  /// Position of container, default is `Center`
  public var viewAttachedPosition: AttachedPosition = .center
  
  /// Padding space between container and popup's view, default is `UIEdgeInsetsZero`
  public var containerPadding = UIEdgeInsets.zero
  
  /// Control the width of container, maximum is 1.0, means container width equals to popup view width, default is `1.0`
  public var widthMultiplier: CGFloat = 0.8
  
  /// Control the width of container with fixed width value
  public var popupWidth: CGFloat {
    get {
      return widthMultiplier * UIScreen.main.bounds.width
    }
    set {
      widthMultiplier = newValue / UIScreen.main.bounds.width
    }
  }
  
  /// Control the width of container, if this property is not 0, the width will always be fixed width in all orientation
  public var fixedWidth: CGFloat = 0
  
  /// Control the height of container, if this property is not 0, the height will always be fixed width in all orientation
  public var fixedHeight: CGFloat = 0
  
  /// Control the height of container, maximum is 1.0, means container height equals to popup view height, default is `1.0`
  public var heightMultiplier: CGFloat = 0.8
  
  /// Control the height of container with fixed height value
  public var popupHeight: CGFloat {
    get {
      return heightMultiplier * UIScreen.main.bounds.height
    }
    set {
      heightMultiplier = newValue / UIScreen.main.bounds.height
    }
  }
    
  /// should auto rotate
  public var autoRotate: Bool = false
  
  /// Corner radius of container, default is `10`
  public var cornerRadius: CGFloat = 8
  
  /// Container's background color, default is `White`
  public var containerBackgroundColor = UIColor.white
  
  /// Container's border width, default is `0` (no border)
  public var borderWidth: CGFloat = 0
  
  /// Container's border color, (if border width is not 0)
  public var borderColor = UIColor.init(white: 0.9, alpha: 1.0)
  
  /// If true container will render shadow, otherwise, false, default is `true`
  public var enableShadow = true
  
  /// Container shadow radius, default is `3`
  public var shadowRadius: CGFloat = 3
  
  /// Container shadow opacity, default is `0.4`
  public var shadowOpacity: CGFloat = 0.4
  
  /// Container shadow offset, default is `(0.5, 0.5)`
  public var shadowOffset = CGSize(width: 0.5, height: 0.5)
  
  /// Container shadow color, default is `white`s
  public var shadowColor = UIColor.darkGray
}

/**
 *  Popup animation appearance
 */
public struct PopupAnimationAppearance {
  /// Popup transition style
  public var transitionStyle: PopupTransitionStyle = .fade
  
  /// Popup transition direction
  public var transitionDirection: PopupTransitionDirection = .leftToRight
  
  /// Popup transition in time duration
  public var transitionInDuration: TimeInterval = 0.4
  
  /// Popup transition out time duration
  public var transitionOutDuration: TimeInterval = 0.2
}

/**
 *  Popup alert controller appearance
 */
public struct PopupAlertControllerAppearance {
  /// Font of title
  public var titleFont = UIFont.systemFont(ofSize: 18)
  
  /// Font of message
  public var messageFont = UIFont.systemFont(ofSize: 14)
  
  /// Horizontal space(for left and right)
  public var horizontalSpace: CGFloat = 16
  
  /// Vertical space(for title and top of the view)
  public var verticalSpaceBetweenTitleAndTop: CGFloat = 18
  
  /// Vertical space(for title and message)
  public var verticalSpaceBetweenTitleAndMessage: CGFloat = 8
  
  /// Vertical space(for message and buttons)
  public var verticalSpaceBetweenMessageAndButtons: CGFloat = 12
  
  /// Height of alert button
  public var alertButtonHeight: CGFloat = 44
  
  /// Font of plain button
  public var plainButtonFont = UIFont.systemFont(ofSize: 14)
  
  /// Title color of plain button
  public var plainButtonTitleColor = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
  
  /// Background color of plain button
  public var plainButtonBackgroundColor = UIColor.white
  
  /// Font of cancel button
  public var cancelButtonFont = UIFont.boldSystemFont(ofSize: 14)
  
  /// Title color of cancel button
  public var cancelButtonTitleColor = UIColor(white: 0.4, alpha: 1)
  
  /// Background color of cancel button
  public var cancelButtonBackgroundColor = UIColor.white
  
  /// If true buttons separator will be rendered, otherwise, false
  public var enableButtonSeparator = true
  
  /// Color of button separator
  public var buttonSeparatorColor = UIColor(white: 0.9, alpha: 1.0)
}

/**
 *  Popup dialogue appearance
 */
public struct PopupDialogueAppearance {
  
  /// Navigation bar background color
  public var navBarBackgroundColor = UIColor(white: 0.97, alpha: 1.0)
  
  /// Navigation title font
  public var titleFont = UIFont.boldSystemFont(ofSize: 18)
  
  /// Navigation title color
  public var titleColor = UIColor.black
  
  /// Navigation bottom separator color 
  public var separatorColor = UIColor(white: 0.8, alpha: 1.0)
}
