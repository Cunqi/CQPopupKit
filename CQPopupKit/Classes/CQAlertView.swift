//
//  CQAlertView.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/4/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Creates an alert view similar to UIAlertController .alertView style
final public class CQAlertView: CQPopupAlertController {
    
    // MARK: Initializer
    
    /**
     Create an alert view
     
     - parameter title:   Title of alert
     - parameter message: Detail description of alert
     - parameter dismiss: Dismiss button text
     
     - returns: Alert View
     */
    public convenience init(title: String, message: String?, dismiss: String?) {
        self.init(title: title, message: message, dismiss: dismiss, options: [])
    }
    
    /**
     Create an alert view
     
     - parameter title:   Title of alert
     - parameter message: Detail description of alert
     - parameter cancel:  Cancel button text
     - parameter confirm: Confirm button text
     
     - returns: Alert view
     */
    public convenience init(title:String, message: String?, cancel: String, confirm: String) {
        self.init(title: title, message: message, dismiss: cancel, options: [confirm])
    }
    
    /**
     Create an alert view
     
     - parameter title:   Title of alert
     - parameter message: Detail description of alert
     - parameter dismiss: Dismiss button text
     - parameter options: Alert Buttons text
     
     - returns: Alert view
     */
    public override init(title: String, message: String?, dismiss: String?, options: [String]) {
        CQAppearance.appearance.popup.viewAttachedPosition = .Center
        CQAppearance.appearance.animation.transitionDirection = .Center
        CQAppearance.appearance.animation.transitionStyle = .Zoom
        super.init(title: title, message: message, dismiss: dismiss, options: options)
    }
    
    // Init with coder not implemented
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     Tell how to layout alert buttons
     
     - parameter parent:  The container view contains all alert buttons
     - parameter buttons: Alert buttons
     */
    override func layoutAlertButtons(at parent: UIView, buttons: [CQPopupAlertButton]) {
        guard buttons.count > 0 else {
            return
        }
        
        let anchorButton = buttons[0]
        parent.bindWith(anchorButton, attribute: .Leading).bindWith(anchorButton, attribute: .Bottom).bindBetween((view: anchorButton, attribute: .Height), and: (view: nil, attribute: .NotAnAttribute), constant: self.alertAppearance.alertButtonHeight)
        
        if self.hasCancelButton && buttons.count == 2 {
            let confirmButton = buttons[1]
            parent.bindWith(anchorButton, attribute: .Width, multiplier: 0.5)
            parent.bindBetween((view: confirmButton, attribute: .Width), and: (view: anchorButton, attribute: .Width))
                    .bindBetween((view: confirmButton, attribute: .Height), and: (view: anchorButton, attribute: .Height))
                    .bindBetween((view: anchorButton, attribute: .Trailing), and: (view: confirmButton, attribute: .Leading))
                    .bindWith(confirmButton, attribute: .Bottom)
            anchorButton.enableRightSeparator = true    //Two buttons on a row, shold render the right separator
        } else {
            parent.bindWith(anchorButton, attribute: .Width)
            var prevButton = anchorButton
            for i in 1 ..< buttons.count {
                let currButton = buttons[i]
                parent.addSubview(currButton)
                parent.bindBetween((view: currButton, attribute: .Height), and: (view: anchorButton, attribute: .Height))
                        .bindBetween((view: currButton, attribute: .Width), and: (view: anchorButton, attribute: .Width))
                        .bindBetween((view: currButton, attribute: .Leading), and: (view: prevButton, attribute: .Leading))
                        .bindBetween((view: currButton, attribute: .Bottom), and: (view: prevButton, attribute: .Top))
                prevButton = currButton
            }
        }
    }
    
    /**
     Tell the width multiplier of alert controller
     
     - returns: Width multiplier of alert controller
     */
    override func calcWidthMultiplier() -> CGFloat {
        return 275 / UIScreen.mainScreen().bounds.width
    }
    
    /**
     Tell the height of alert buttons based on the layout of alert buttons
     
     - returns: Maximum height of alert buttons
     */
    override func calcHeightOfAlertButtons() -> CGFloat {
        if self.hasCancelButton && self.alertButtons.count <= 2 {
            return self.alertAppearance.alertButtonHeight
        } else if (!self.hasCancelButton) || (self.hasCancelButton && self.alertButtons.count > 2) {
            return self.alertAppearance.alertButtonHeight * CGFloat(self.alertButtons.count)
        } else {
            return 0
        }
    }
}
