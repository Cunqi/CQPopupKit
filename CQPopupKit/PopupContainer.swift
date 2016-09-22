//
// Created by Cunqi.X on 8/4/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/**
 Container type
 
 - shadow: For Container shadow rendering
 - plain:  Normal container
 */
enum ContainerType: Int {
  case shadow = 0
  case plain = 1
}

/// Popup container
final class PopupContainer: UIView {
  // MARK: Private & Internal
  
  /// Container type
  let type: ContainerType
  
  /// Container appearance
  let appearance: PopupAppearance
  
  // MARK: Initializer
  
  /**
   Create a popup container
   
   - parameter type:       Container type
   - parameter appearance: Container appearance
   
   - returns: Popup container
   */
  init(containerType type: ContainerType, appearance: PopupAppearance) {
    self.type = type
    self.appearance = appearance
    
    super.init(frame: CGRect.zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  // Init with coder not implemented
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /**
   Render itself
   */
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = appearance.cornerRadius
    
    if type == .plain {
      backgroundColor = appearance.containerBackgroundColor
      layer.masksToBounds = true
      layer.borderWidth = appearance.borderWidth
      layer.borderColor = appearance.borderColor.cgColor
      
    } else if appearance.enableShadow {
      backgroundColor = UIColor.clear
      layer.shadowRadius = appearance.shadowRadius
      layer.shadowOpacity = Float(appearance.shadowOpacity)
      layer.shadowOffset = appearance.shadowOffset
      layer.shadowColor = appearance.shadowColor.cgColor
    }
  }
}
