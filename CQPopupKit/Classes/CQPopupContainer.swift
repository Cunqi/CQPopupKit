//
// Created by Cunqi.X on 8/4/16.
// Copyright (c) 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/**
 Container type
 
 - Shadow: For Container shadow rendering
 - Plain:  Normal container
 */
enum ContainerType: Int {
  case Shadow = 0
  case Plain = 1
}

/// Popup container
final class CQPopupContainer: UIView {
  // MARK: Private & Internal
  
  /// Container type
  let type: ContainerType
  
  /// Container appearance
  let appearance: CQPopupAppearance
  
  // MARK: Initializer
  
  /**
   Create a popup container
   
   - parameter type:       Container type
   - parameter appearance: Container appearance
   
   - returns: Popup container
   */
  init(containerType type: ContainerType, appearance: CQPopupAppearance) {
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
    
    if type == .Plain {
      backgroundColor = appearance.containerBackgroundColor
      layer.masksToBounds = true
      layer.borderWidth = appearance.borderWidth
      layer.borderColor = appearance.borderColor.CGColor
      
    } else if appearance.enableShadow {
      backgroundColor = UIColor.clearColor()
      layer.shadowRadius = appearance.shadowRadius
      layer.shadowOpacity = Float(appearance.shadowOpacity)
      layer.shadowOffset = appearance.shadowOffset
      layer.shadowColor = appearance.shadowColor.CGColor
    }
  }
}
