//
//  CQAlertView.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/4/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Creates an alert view similar to UIAlertController .alertView style
public final class CQAlertView: PopupAlertController {
  
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
    super.init(title: title, message: message, dismiss: dismiss, options: options)
    appearance.viewAttachedPosition = .center
    appearance.fixedWidth = 275
    animationAppearance.transitionDirection = .center
    animationAppearance.transitionStyle = .zoom
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
  override func layoutAlertButtons(at parent: UIView, buttons: [PopupAlertButton]) {
    guard buttons.count > 0 else {
      return
    }
    
    let anchorButton = buttons[0]
    parent.bindWith(anchorButton, attribute: .Leading)
    parent.bindWith(anchorButton, attribute: .Bottom)
    parent.bind(anchorButton, attribute: .Height, to: nil, toAttribute: .NotAnAttribute, constant: alertAppearance.alertButtonHeight)
    
    if hasCancelButton && buttons.count == 2 {
      let confirmButton = buttons[1]
      parent.bindWith(anchorButton, attribute: .Width, multiplier: 0.5)
      parent.bind(confirmButton, attribute: .Width, to: anchorButton)
      parent.bind(confirmButton, attribute: .Height, to: anchorButton)
      parent.bind(anchorButton, attribute: .Trailing, to: confirmButton, toAttribute: .Leading)
      parent.bindWith(confirmButton, attribute: .Bottom)
      anchorButton.enableRightSeparator = true    //Two buttons on a row, shold render the right separator
    } else {
      parent.bindWith(anchorButton, attribute: .Width)
      var prevButton = anchorButton
      for i in 1 ..< buttons.count {
        let currButton = buttons[i]
        parent.addSubview(currButton)
        parent.bind(currButton, attribute: .Width, to: anchorButton)
        parent.bind(currButton, attribute: .Height, to: anchorButton)
        parent.bind(currButton, attribute: .Leading, to: prevButton)
        parent.bind(currButton, attribute: .Bottom, to: prevButton, toAttribute: .Top)
        prevButton = currButton
      }
    }
  }
  
  /**
   Tell the height of alert buttons based on the layout of alert buttons
   
   - returns: Maximum height of alert buttons
   */
  override func calcHeightOfAlertButtons() -> CGFloat {
    if hasCancelButton && alertButtons.count <= 2 {
      return alertAppearance.alertButtonHeight
    } else if (!hasCancelButton) || (hasCancelButton && alertButtons.count > 2) {
      return alertAppearance.alertButtonHeight * CGFloat(alertButtons.count)
    } else {
      return 0
    }
  }
}
