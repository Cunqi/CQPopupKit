//
//  CQActionSheet.swift
//  Pods
//
//  Created by Cunqi.X on 8/8/16.
//
//

import UIKit

/// Creates an alert view similar to UIAlertController .actionSheet style
public class CQActionSheet: PopupAlertController {
  // MARK: Initializer
  
  /**
   Create an action sheet popup
   
   - parameter title:   Action sheet title
   - parameter message: Action sheet description message
   - parameter dismiss: Action sheet cancel button
   - parameter options: Action sheet options
   
   - returns: Action sheet popup
   */
  public override init(title: String, message: String?, dismiss: String?, options: [String]) {
    super.init(title: title, message: message, dismiss: dismiss, options: options)
    appearance.viewAttachedPosition = .bottom
    appearance.containerPadding = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    appearance.fixedWidth = 0.95 * min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    alertAppearance.messageFont = UIFont.systemFontOfSize(12)
    animationAppearance.transitionDirection = .bottomToTop
    animationAppearance.transitionStyle = .plain
    animationAppearance.transitionInDuration = 0.3
    animationAppearance.transitionInDuration = 0.15
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutAlertButtons(at parent: UIView, buttons: [PopupAlertButton]) {
    let anchorButton = buttons[0]
    parent.bindWith(anchorButton, attribute: .Leading).bindWith(anchorButton, attribute: .Bottom).bind(anchorButton, attribute: .Height, to: nil, toAttribute: .NotAnAttribute, constant: alertAppearance.alertButtonHeight)
    parent.bindWith(anchorButton, attribute: .Width)
    var prevButton = anchorButton
    for i in 1 ..< buttons.count {
      let currButton = buttons[i]
      parent.addSubview(currButton)
      parent.bind(currButton, attribute: .Width, to: anchorButton)
        .bind(currButton, attribute: .Height, to: anchorButton)
        .bind(currButton, attribute: .Leading, to: anchorButton)
        .bind(currButton, attribute: .Bottom, to: prevButton, toAttribute: .Top)
      prevButton = currButton
    }
  }
  
  override func calcHeightOfAlertButtons() -> CGFloat {
    return alertAppearance.alertButtonHeight * CGFloat(alertButtons.count)
  }
}
