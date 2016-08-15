//
//  CQDatePicker.swift
//  CQPopupKit
//
//  Created by Cunqi.X on 8/14/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Popup date picker
public final class CQDatePicker: PopupDialogue {
  
  // MARK: Public
  
  /// Date picker
  public let datePicker = UIDatePicker(frame: .zero)
  
  /// Cancel action when cancel button is tapped
  public var cancelAction: (() -> Void)?
  
  /// Confirm action when confirm button is tapped
  public var confirmAction: ((NSDate) -> Void)?
  
  // MARK: Initializer
  
  /**
   Popup date picker
   
   - parameter title:       Date picker title
   - parameter mode:        Date picker mode
   - parameter cancelText:  Cancel button text
   - parameter confirmText: Confirm button text
   
   - returns: Popup date picker
   */
  public init(title: String, mode: UIDatePickerMode, cancelText: String = "Cancel", confirmText: String = "Choose") {
    datePicker.datePickerMode = mode
    super.init(title: title, contentView: datePicker, positiveAction: nil, negativeAction: nil, cancelText: cancelText, confirmText: confirmText)
    
    negativeAction = { (popupInfo) in
      if let action = self.cancelAction {
        action()
      }
    }
    
    positiveAction = { (popupInfo) in
      if let action = self.confirmAction {
        let date = popupInfo!["selectedDate"] as! NSDate
        action(date)
      }
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - PopupDialogueDelegate
extension UIDatePicker: PopupDialogueDelegate {
  public func prepareConfirmedData() -> [NSObject : AnyObject]? {
    return ["selectedDate": self.date]
  }
}
