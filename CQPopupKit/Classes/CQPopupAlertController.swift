//
//  CQPopupAlertController.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/4/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Root class of AlertView and ActionSheet
public class CQPopupAlertController: CQPopup {
  
  // MARK: Public
  
  /// Alert controller appearance
  public var alertAppearance = CQAppearance.appearance.alert
  
  /// Title of alert controller
  public var titleText: String!
  
  /// Message of alert controller
  public var messageText: String?
  
  /// Title of cancel button
  public var cancelTitle: String?
  
  /// Titles of each option
  public var itemOptions: [String]!
  
  /// Invoke alert canceled action when alert controller receives negative notification
  public var alertCanceledAction: (() -> Void)?
  
  /// Invoke alert selected action when alert controller receives positive notification
  public var alertSelectedAction: ((Int, String) -> Void)?
  
  /// Get the alert title label
  public private(set) var alertTitle: UILabel!
  
  /// Get the alert message label
  public private(set) var alertMessage: UILabel!
  
  /// Get the alert buttons
  public private(set) var alertButtons: [CQPopupAlertButton]!
  
  // MARK: Private & Internal
  
  /// Use to get the selected action index in PopupAction
  private let selectedIndex = "selectedIndex"
  
  /// Use to get the selected action title in PopupAction
  private let selectedTitle = "selectedTitle"
  
  /// Content view contains alert title, alert message, and alert buttons
  private var content: UIView
  
  /// If cancel title had been set correctly, return true, otherwise, false
  var hasCancelButton: Bool {
    get {
      return cancelTitle != nil
    }
  }
  
  // MARK: Initializer
  
  /**
   Create an alert controller
   
   - parameter title:   Alert controller title
   - parameter message: Alert controller message
   - parameter dismiss: dismiss button text
   - parameter options: alert options text
   
   - returns: alert controller
   */
  public init(title: String, message: String?, dismiss: String?, options: [String] = []) {
    // create container for alert title, message and buttons
    content = UIView()
    content.translatesAutoresizingMaskIntoConstraints = false
    super.init(contentView: content, negativeAction: nil, positiveAction: nil)
    
    titleText = title
    messageText = message
    cancelTitle = dismiss
    itemOptions = options
    
    alertTitle = configureAlertTitle()
    alertMessage = configureAlertMessage()
    alertButtons = configureAlertButtons()
    
    negativeAction = {popUpInfo in
      if let action = self.alertCanceledAction {
        action()
      }
    }
    
    positiveAction = {popUpInfo in
      if let info = popUpInfo, let action = self.alertSelectedAction {
        let index = info[self.selectedIndex] as! Int
        let title = info[self.selectedTitle] as! String
        action(index, title)
      }
    }
  }
  
  // Init with coder not implemented
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure alert controller components
  
  /**
   Configure alert title view, set text, bind constraints
   
   - returns: Alert title
   */
  private func configureAlertTitle() -> UILabel {
    let title = createLabel(alertAppearance.titleFont)
    title.text = titleText
    content.addSubview(title)
    
    let hs = alertAppearance.horizontalSpace
    let constant = alertAppearance.verticalSpaceBetweenTitleAndTop
    content.bindWith(title, attribute: .Top, constant: constant).bindFrom("H:|-(\(hs))-[title]-(\(hs))-|", views: ["title" : title])
    return title
  }
  
  /**
   Configure alert message view, set text, bind constraints
   
   - returns: Alert message
   */
  private func configureAlertMessage() -> UILabel {
    let message = createLabel(alertAppearance.messageFont)
    message.text = messageText
    content.addSubview(message)
    
    let hs = alertAppearance.horizontalSpace
    let constant = alertAppearance.verticalSpaceBetweenTitleAndMessage
    content.bindBetween((view: message, attribute: .Top), and: (view: alertTitle, attribute: .Bottom), constant: constant).bindFrom("H:|-(\(hs))-[message]-(\(hs))-|", views: ["message" : message])
    return message
  }
  
  /**
   Configure alert buttons, bind constraints
   
   - returns: Alert buttons
   */
  private func configureAlertButtons() -> [CQPopupAlertButton] {
    //let subclass implement
    var buttons = [CQPopupAlertButton]()
    if hasCancelButton {   //if cancel button was set, set it with Cancel style
      let cancelButton = CQPopupAlertButton(style: .Cancel, title: cancelTitle!, appearance: alertAppearance)
      cancelButton.addTarget(self, action: #selector(cancelButtonSelected), forControlEvents: .TouchUpInside)
      content.addSubview(cancelButton)
      buttons.append(cancelButton)
    }
    
    for option in itemOptions {    //set other buttons with Plain style
      let button = CQPopupAlertButton(style: .Plain, title: option, appearance: alertAppearance)
      button.addTarget(self, action: #selector(buttonSelected), forControlEvents: .TouchUpInside)
      content.addSubview(button)
      buttons.append(button)
    }
    return buttons
  }
  
  
  // MARK: View Controller life cycle
  
  public final override func viewDidLoad() {
    layoutAlertButtons(at: content, buttons: alertButtons)
    appearance.heightMultiplier = calcNecessaryHeightMultiplier()
    super.viewDidLoad()
  }
  
  public final override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    alertCanceledAction = nil
    alertSelectedAction = nil
  }
  
  /**
   Calculate minimum necessary height to fully display alert controller
   
   - returns: Minimum necessary height of alert controller
   */
  private func calcNecessaryHeightMultiplier() -> CGFloat {
    let titleHeight = calcHeightOfAlertTitle() + alertAppearance.verticalSpaceBetweenTitleAndTop
    let messageHeight = calcHeightOfAlertMessage() + alertAppearance.verticalSpaceBetweenTitleAndMessage
    let buttonsHeight = alertAppearance.verticalSpaceBetweenMessageAndButtons + calcHeightOfAlertButtons()
    return (titleHeight + messageHeight + buttonsHeight) / UIScreen.mainScreen().bounds.height
  }
  
  
  /**
   Calculate height of alert title
   
   - returns: Height of alert title
   */
  private func calcHeightOfAlertTitle() -> CGFloat {
    let width = appearance.widthMultiplier * UIScreen.mainScreen().bounds.width
    return alertTitle.font.sizeOfString(titleText, constrainedToWidth: Double(width - alertAppearance.horizontalSpace - alertAppearance.horizontalSpace)).height
  }
  
  /**
   Calculate height of alert message
   
   - returns: Height of alert message
   */
  private func calcHeightOfAlertMessage() -> CGFloat {
    guard let text = messageText else {
      return 0
    }
    let width = appearance.widthMultiplier * UIScreen.mainScreen().bounds.width
    return alertMessage.font.sizeOfString(text, constrainedToWidth: Double(width - alertAppearance.horizontalSpace - alertAppearance.horizontalSpace)).height
  }
  
  /**
   Cancel button tapped action
   
   - parameter sender: Cancel button
   */
  func cancelButtonSelected(sender: AnyObject) {
    CQPopup.sendPopupNegative(nil)
  }
  
  /**
   Any alert button selected action
   
   - parameter sender: Selected alert button
   */
  func buttonSelected(sender: AnyObject) {
    let button = sender as! UIButton
    let title = button.titleForState(.Normal)!
    let index = itemOptions.indexOf(title)!
    CQPopup.sendPopupPositive([selectedIndex: index, selectedTitle:title])
  }
  
  /**
   Help to create an UILabel
   
   - parameter font: Font of label
   
   - returns: UILabel instance
   */
  private func createLabel(font: UIFont) -> UILabel {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.font = font
    title.textAlignment = .Center
    title.numberOfLines = 0
    return title
  }
  
  // MARK: Required method
  
  /**
   Subclass should implement this method to layout alert buttons
   
   - parameter parent:  The container view contains all alert buttons
   - parameter buttons: Alert buttons
   */
  func layoutAlertButtons(at parent: UIView, buttons: [CQPopupAlertButton]) {}
  
  /**
   Subclass should implement this method to calculate the height of alert buttons based on the layout of alert buttons
   
   - returns: Maximum height of alert buttons
   */
  func calcHeightOfAlertButtons() -> CGFloat {return 0}
}

/**
 Alert button style
 
 - Plain:       Plain style
 - Cancel:      Cancel style
 - Destructive: Destructive style
 */
public enum CQPopupAlertButtonStype: Int {
  case Plain = 0
  case Cancel = 1
}

/// Popup Alert Button
public class CQPopupAlertButton: UIButton {
  
  // MARK: Private & Internal
  
  /// Button style
  let style: CQPopupAlertButtonStype
  
  /// Top separator
  private lazy var topSeparator: UIView = {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    return separator
  }()
  
  /// Right separator (Cancel Button only)
  private lazy var rightSeparator: UIView = {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    return separator
  }()
  
  /// if true right separator will be rendered, otherwise, false
  var enableRightSeparator: Bool = false {
    willSet {
      rightSeparator.alpha = newValue ? 1.0 : 0.0
    }
  }
  
  // MARK: Initializer
  
  /**
   Creates popup alert button with style and title
   
   - parameter style: CQPopupAlertButtonStyle
   - parameter title: Button title
   
   - returns: Popup alert button
   */
  init(style: CQPopupAlertButtonStype, title: String, appearance: CQAlertControllerAppearance?) {
    self.style = style
    super.init(frame: .zero)
    setTitle(title, forState: .Normal)
    setTitleColor(UIColor.blackColor(), forState: .Normal)
    translatesAutoresizingMaskIntoConstraints = false
    
    guard let _ = appearance else {return}
    
    if appearance!.enableButtonSeparator {
      topSeparator.backgroundColor = appearance!.buttonSeparatorColor
      addSubview(topSeparator)
      bindFrom("V:|[separator(1)]", views: ["separator": topSeparator]).bindFrom("H:|[separator]|", views: ["separator": topSeparator])
      
      if style == .Cancel {
        rightSeparator.backgroundColor = appearance!.buttonSeparatorColor
        addSubview(rightSeparator)
        
        bindFrom("H:[separator(1)]|", views: ["separator": rightSeparator]).bindFrom("V:|[separator]|", views: ["separator": rightSeparator])
      }
    }
    
    switch style {
    case .Plain:
      backgroundColor = appearance!.plainButtonBackgroundColor
      titleLabel?.font = appearance!.plainButtonFont
      setTitleColor(appearance!.plainButtonTitleColor, forState: .Normal)
    case .Cancel:
      backgroundColor = appearance!.cancelButtonBackgroundColor
      titleLabel?.font = appearance!.cancelButtonFont
      setTitleColor(appearance!.cancelButtonTitleColor, forState: .Normal)
    }
  }
  
  // Init with coder not implemented
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}