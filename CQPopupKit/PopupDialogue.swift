//
//  PopupDialogue.swift
//  CQPopupKit
//
//  Created by Cunqi.X on 8/13/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Popup dialogue delegate
public protocol PopupDialogueDelegate: class {
  /**
   When confirm button tapped, call invokePositiveAction to send confirmed data
   
   - returns: confirmed data
   */
  func prepareConfirmedData() -> Any?
}

/// Popup view with navigation bar on the top, contains title, cancel button, confirm button
open class PopupDialogue: Popup {
  
  // MARK: Public
  
  /// Navigation bar view
  open let navBar = UIView()
  
  /// Title label
  open let dialogueTitle = UILabel(frame: .zero)
  
  /// Cancel button
  open let cancel = UIButton(type: .system)
  
  /// Confirm button
  open let confirm = UIButton(type: .system)
  
  /// Dialogue appearance
  open var dialogueAppearance: PopupDialogueAppearance!
  
  /// PopupDialogueDelegate
  fileprivate weak var delegate: PopupDialogueDelegate?
  
  // MARK: Initializer
  
  /**
   Creates a popup dialogue
   
   - parameter title:          Dialogue title text
   - parameter contentView:    Custom content view
   - parameter positiveAction: Action when confirm button is tapped
   - parameter negativeAction: Action when cancel button is tapped
   - parameter cancelText:     Cancel button text
   - parameter confirmText:    Confirm button text
   
   - returns: Popup dialogue
   */
  public init(title: String, contentView: UIView?, positiveAction: PopupAction?, negativeAction: PopupAction? = nil, cancelText: String = "Cancel", confirmText: String = "Choose") {
    dialogueAppearance = CQAppearance.appearance.dialogue
    super.init(contentView: contentView, positiveAction: positiveAction, negativeAction: negativeAction)
    
    if let delegate = self.contentView as? PopupDialogueDelegate {
      self.delegate = delegate 
    }
    
    navBar.backgroundColor = dialogueAppearance.navBarBackgroundColor
    
    dialogueTitle.text = title
    dialogueTitle.font = dialogueAppearance.titleFont
    dialogueTitle.textColor = dialogueAppearance.titleColor
    dialogueTitle.textAlignment = .center
    dialogueTitle.numberOfLines = 1
    
    cancel.setTitle(cancelText, for: UIControlState())
    cancel.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
    
    confirm.setTitle(confirmText, for: UIControlState())
    confirm.addTarget(self, action: #selector(tapToConfirm), for: .touchUpInside)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /**
   Bind constraints to navigation bar and content view
   */
  override func installContentView() {
    installNavBar()
    installContent()
  }
  
  /**
   When confirm button is tapped
   */
  func tapToConfirm() {
    guard let _ = self.delegate else {
      self.tapToDismiss()
      return
    }
    let popupInfo = self.delegate!.prepareConfirmedData()
    invokePositiveAction(popupInfo)
  }

  fileprivate func installNavBar() {
    // Cancel button
    cancel.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(cancel)
    navBar.bindFrom("V:|[cancel]|", views: ["cancel": cancel])
    navBar.bindWith(cancel, attribute: .leading)
    navBar.bindWith(cancel, attribute: .width, multiplier: 0.25)
    
    // Confirm button
    confirm.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(confirm)
    navBar.bindFrom("V:|[confirm]|", views: ["confirm": confirm])
    navBar.bindWith(confirm, attribute: .trailing)
    navBar.bindWith(confirm, attribute: .width, multiplier: 0.25)
    
    // Title Label
    dialogueTitle.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(dialogueTitle)
    navBar.bindFrom("V:|[title]|", views: ["title": dialogueTitle])
    navBar.bind(cancel, attribute: .trailing, to: dialogueTitle, toAttribute: .leading)
    navBar.bind(confirm, attribute: .leading, to: dialogueTitle, toAttribute: .trailing)
    
    // Bottom Separator
    let bottomSeparator = UIView(frame: .zero)
    bottomSeparator.backgroundColor = dialogueAppearance.separatorColor
    bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(bottomSeparator)
    navBar.bindFrom("H:|[separator]|", views: ["separator": bottomSeparator])
    navBar.bindWith(bottomSeparator, attribute: .bottom)
    navBar.bind(bottomSeparator, attribute: .height, to: nil, toAttribute: .notAnAttribute, constant: 1.0)
    
    navBar.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(navBar)
    
    container.bind(navBar, attribute: .height, to: nil, toAttribute: .notAnAttribute, constant: 44)
    container.bindFrom("H:|[nav]|", views: ["nav": navBar])
    container.bindWith(navBar, attribute: .top)
  }
  
  func installContent() {
    if let content = contentView {
      content.translatesAutoresizingMaskIntoConstraints = false
      container.addSubview(content)
      container.bindFrom("H:|[content]|", views: ["content": content])
      container.bindWith(content, attribute: .bottom)
      container.bind(navBar, attribute: .bottom, to: content, toAttribute: .top)
    }
  }
}
