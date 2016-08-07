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
        self.translatesAutoresizingMaskIntoConstraints = false
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

        self.layer.cornerRadius = self.appearance.cornerRadius

        if self.type == .Plain {
            self.backgroundColor = self.appearance.containerBackgroundColor
            self.layer.masksToBounds = true
            self.layer.borderWidth = self.appearance.borderWidth
            self.layer.borderColor = self.appearance.borderColor.CGColor

        } else if self.appearance.enableShadow {
            self.backgroundColor = UIColor.clearColor()
            self.layer.shadowRadius = self.appearance.shadowRadius
            self.layer.shadowOpacity = Float(self.appearance.shadowOpacity)
            self.layer.shadowOffset = self.appearance.shadowOffset
            self.layer.shadowColor = self.appearance.shadowColor.CGColor
        }
    }
}
