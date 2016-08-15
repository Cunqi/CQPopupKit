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
  func prepareConfirmedData() -> [NSObject: AnyObject]?
}

/// Popup view with navigation bar on the top, contains title, cancel button, confirm button
public class PopupDialogue: Popup {
  
  // MARK: Public
  
  /// Navigation bar view
  public let navBar = UIView()
  
  /// Title label
  public let dialogueTitle = UILabel(frame: .zero)
  
  /// Cancel button
  public let cancel = UIButton(type: .System)
  
  /// Confirm button
  public let confirm = UIButton(type: .System)
  
  /// Dialogue appearance
  public var dialogueAppearance: PopupDialogueAppearance!
  
  /// PopupDialogueDelegate
  private weak var delegate: PopupDialogueDelegate?
  
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
    dialogueTitle.textAlignment = .Center
    dialogueTitle.numberOfLines = 1
    
    cancel.setTitle(cancelText, forState: .Normal)
    cancel.addTarget(self, action: #selector(tapToDismiss), forControlEvents: .TouchUpInside)
    
    confirm.setTitle(confirmText, forState: .Normal)
    confirm.addTarget(self, action: #selector(tapToConfirm), forControlEvents: .TouchUpInside)
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
  
  private func installNavBar() {
    // Cancel button
    cancel.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(cancel)
    navBar.bindFrom("V:|[cancel]|", views: ["cancel": cancel])
    navBar.bindWith(cancel, attribute: .Leading)
    navBar.bindWith(cancel, attribute: .Width, multiplier: 0.25)
    
    // Confirm button
    confirm.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(confirm)
    navBar.bindFrom("V:|[confirm]|", views: ["confirm": confirm])
    navBar.bindWith(confirm, attribute: .Trailing)
    navBar.bindWith(confirm, attribute: .Width, multiplier: 0.25)
    
    // Title Label
    dialogueTitle.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(dialogueTitle)
    navBar.bindFrom("V:|[title]|", views: ["title": dialogueTitle])
    navBar.bind(cancel, attribute: .Trailing, to: dialogueTitle, toAttribute: .Leading)
    navBar.bind(confirm, attribute: .Leading, to: dialogueTitle, toAttribute: .Trailing)
    
    // Bottom Separator
    let bottomSeparator = UIView(frame: .zero)
    bottomSeparator.backgroundColor = dialogueAppearance.separatorColor
    bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
    navBar.addSubview(bottomSeparator)
    navBar.bindFrom("H:|[separator]|", views: ["separator": bottomSeparator])
    navBar.bindWith(bottomSeparator, attribute: .Bottom)
    navBar.bind(bottomSeparator, attribute: .Height, to: nil, toAttribute: .NotAnAttribute, constant: 1.0)
    
    navBar.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(navBar)
    
    container.bind(navBar, attribute: .Height, to: nil, toAttribute: .NotAnAttribute, constant: 44)
    container.bindFrom("H:|[nav]|", views: ["nav": navBar])
    container.bindWith(navBar, attribute: .Top)
  }
  
  func installContent() {
    if let content = contentView {
      content.translatesAutoresizingMaskIntoConstraints = false
      container.addSubview(content)
      container.bindFrom("H:|[content]|", views: ["content": content])
      container.bindWith(content, attribute: .Bottom)
      container.bind(navBar, attribute: .Bottom, to: content, toAttribute: .Top)
    }
  }
}
