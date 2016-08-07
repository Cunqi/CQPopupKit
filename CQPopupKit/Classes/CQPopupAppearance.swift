//
//  CQPopupAppearance.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/5/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/**
 Popup transition animation style
 
 - Zoom:   Zoom in and zoom out (Center direction ONLY)
 - Fade:   Fade in and fade out
 - Bounce: Bounce in and bounce out
 - Custom: Custom implementation
 */
@objc public enum CQPopupTransitionStyle: Int {
    case Zoom = 0
    case Fade = 1
    case Bounce = 2
    case Custom = 3
}

/**
 Popup transition animation direction
 
 - LeftToRight: From left to right
 - RightToLeft: From right to left
 - TopToBottom: From top to bottom
 - BottomToTop: From bottom to top
 - Center:      Stay at center (For Zoom / Custom transition style ONLY!)
 */
@objc public enum CQPopupTransitionDirection: Int {
    case LeftToRight = 0
    case RightToLeft = 1
    case TopToBottom = 2
    case BottomToTop = 3
    case Center = 4
}

/**
 Current animation status of transition in / transition out
 
 - In:  Transition in
 - Out: Transition out
 */
@objc public enum CQPopupAnimationStatus: Int {
    case In = 0
    case Out = 1
}

/// The appearance of pop up
@objc public class CQPopupAppearance: NSObject {
    
    /// Default appearance of popup
    public static let appearance = CQPopupAppearance()
    
    /// Background color of pop up
    public var popUpBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.5)
    
    /// If ture tap outside of the container will dimiss the popup, otherwise false, default is `true`
    public var enableTouchOutsideToDismiss: Bool = true
    
    /// Position of container, default is `Center`
    public var viewAttachedPosition: AttachedPosition = .Center
    
    /// Padding space between container and popup's view, defalut is `UIEdgeInsetsZero`
    public var containerPadding: UIEdgeInsets = UIEdgeInsetsZero
    
    /// Control the width of container, maximum is 1.0, means container width equals to popup view width, default is `1.0`
    public var widthMultiplier: CGFloat = 1.0
    
    /// Control the height of container, maximum is 1.0, means container height equals to popup view height, default is `1.0`
    public var heightMultiplier: CGFloat = 1.0
    
    /// Corner radius of container, default is `5`
    public var cornerRadius: CGFloat = 5
    
    /// Container's background color, default is `White`
    public var containerBackgroundColor: UIColor = UIColor.whiteColor()
    
    /// Container's border width, default is `0` (no border)
    public var borderWidth: CGFloat = 0
    
    /// Container's border color, (if border width is not 0)
    public var borderColor: UIColor = UIColor.init(white: 0.9, alpha: 1.0)
    
    /// If true container will render shadow, otherwise, false, default is `true`
    public var enableShadow: Bool = true
    
    /// Container shadow radius, default is `3`
    public var shadowRadius: CGFloat = 3
    
    /// Container shadow opacity, default is `0.4`
    public var shadowOpacity: CGFloat = 0.4
    
    /// Container shadow offset, default is `(0.5, 0.5)`
    public var shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5)
    
    /// Container shadow color, default is `white`s
    public var shadowColor: UIColor = UIColor.whiteColor()
    
    /// Popup transition style
    public var transitionStyle: CQPopupTransitionStyle = .Fade
    
    /// Popup transition direction
    public var transitionDirection: CQPopupTransitionDirection = .LeftToRight
    
    /// Popup transition in time duration
    public var transitionInDuration: NSTimeInterval = 0.6
    
    /// Popup transition out time duration
    public var transitionOutDuration: NSTimeInterval = 0.3
    
    // MARK: Initializer
    
    private override init(){}
}

/**
 *  Alert controller metrics, control alert controller's size, padding, button size, etc
 */
@objc public class CQAlertControllerAppearance: NSObject {
    
    /// Default appearance of alert controller
    static let appearance = CQAlertControllerAppearance()
    
    /// Font of title
    public var titleFont: UIFont = UIFont.systemFontOfSize(18)
    
    /// Font of message
    public var messageFont: UIFont = UIFont.systemFontOfSize(14)
    
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
    public var plainButtonFont: UIFont = UIFont.systemFontOfSize(14)
    
    /// Title color of plain button
    public var plainButtonTitleColor: UIColor = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
    
    /// Background color of plain button
    public var plainButtonBackgroundColor: UIColor = UIColor.whiteColor()
    
    /// Font of cancel button
    public var cancelButtonFont: UIFont = UIFont.boldSystemFontOfSize(14)
    
    /// Title color of cancel button
    public var cancelButtonTitleColor: UIColor = UIColor(white: 0.4, alpha: 1)
    
    /// Background color of cancel button
    public var cancelButtonBackgroundColor: UIColor = UIColor.whiteColor()
    
    /// If true buttons separator will be rendered, otherwise, false
    public var enableButtonSeparator: Bool = true
    
    /// Color of button separator
    public var buttonSeparatorColor: UIColor = UIColor(white: 0.9, alpha: 1.0)

    // MARK: Initializer
    
    private override init(){}
}