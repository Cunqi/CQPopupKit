//
//  CQPicker.swift
//  CQPopupKit
//
//  Created by Cunqi.X on 8/14/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Popup picker with custom data
public final class CQPicker: PopupDialogue {
  
  // MARK: Public
  
  /// UIPickerView
  public let picker = UIPickerView(frame: .zero)
  
  /// Multi options, each component has an array of data
  public var multiOptions: [[String]]!
  
  /// Row height of each item in picker view
  public var rowHeight: CGFloat = 44
  
  /// Cancel action when cancel button tapped
  public var cancelAction: (() -> Void)?
  
  /// Confirm action when confirm button tapped
  public var confirmAction: ([String] -> Void)?
  
  // MARK: Initializer
  
  /**
   Popup piker view
   
   - parameter title:       Picker view title
   - parameter options:     Single component options
   - parameter cancelText:  Cancel button text
   - parameter confirmText: Confirm button text
   
   - returns: Popup picker view
   */
  public convenience init(title: String, options: [String], cancelText: String = "Cancel", confirmText: String = "Choose") {
    self.init(title: title, multiOptions: [options], cancelText: cancelText, confirmText: confirmText)
  }
  
  /**
   Popup picker view
   
   - parameter title:        Picker view title
   - parameter multiOptions: Multi component options
   - parameter cancelText:   Cancel button text
   - parameter confirmText:  Confirm button text
   
   - returns: Popup picker view
   */
  public init (title: String, multiOptions: [[String]], cancelText: String, confirmText: String) {
    super.init(title: title, contentView: picker, positiveAction: nil, negativeAction: nil, cancelText: cancelText, confirmText: confirmText)
    
    self.multiOptions = multiOptions
    
    picker.dataSource = self
    picker.delegate = self
    
    negativeAction = { (popupInfo) in
      if let action = self.cancelAction {
        action()
      }
    }
    
    positiveAction = { (popupInfo) in
      if let action = self.confirmAction {
        let options = popupInfo!["options"]! as! [String]
        action(options)
      }
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UIPickerViewDataSource
extension CQPicker: UIPickerViewDataSource {
  public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return multiOptions.count
  }
  
  public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return multiOptions[component].count
  }
}

// MARK: - UIPickerViewDelegate
extension CQPicker: UIPickerViewDelegate {
  public func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return rowHeight
  }
  
  public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let options = multiOptions[component]
    return options[row]
  }
}

// MARK: - PopupDialogueDelegate
extension UIPickerView: PopupDialogueDelegate {
  public func prepareConfirmedData() -> [NSObject : AnyObject]? {
    var options: [String] = []
    
    for i in 0 ..< numberOfComponents {
      let index = self.selectedRowInComponent(i)
      options.append((self.delegate?.pickerView!(self, titleForRow: index, forComponent: i))!)
    }
    
    return ["options": options]
  }
}