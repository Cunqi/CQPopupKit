//
//  CQActionSheet.swift
//  Pods
//
//  Created by Cunqi.X on 8/8/16.
//
//

import UIKit

/// Creates an alert view similar to UIAlertController .actionSheet style
public class CQActionSheet: CQPopupAlertController {
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
    appearance.widthMultiplier = 0.95
    alertAppearance.messageFont = UIFont.systemFontOfSize(12)
    animationAppearance.transitionDirection = .bottomToTop
    animationAppearance.transitionStyle = .plain
    animationAppearance.transitionInDuration = 0.3
    animationAppearance.transitionInDuration = 0.15
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutAlertButtons(at parent: UIView, buttons: [CQPopupAlertButton]) {
    let anchorButton = buttons[0]
    parent.bindWith(anchorButton, attribute: .Leading).bindWith(anchorButton, attribute: .Bottom).bindBetween((view: anchorButton, attribute: .Height), and: (view: nil, attribute: .NotAnAttribute), constant: alertAppearance.alertButtonHeight)
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
  
  override func calcHeightOfAlertButtons() -> CGFloat {
    return alertAppearance.alertButtonHeight * CGFloat(alertButtons.count)
  }
}
