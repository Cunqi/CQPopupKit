//
//  PopupAlertController.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/4/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Root class of AlertView and ActionSheet
open class PopupAlertController: Popup {
  
  // MARK: Public
  
  /// Alert controller appearance
  open var alertAppearance = CQAppearance.appearance.alert
  
  /// Title of alert controller
  open var titleText: String!
  
  /// Message of alert controller
  open var messageText: String?
  
  /// Title of cancel button
  open var cancelTitle: String?
  
  /// Titles of each option
  open var itemOptions: [String]!

  /// Get the alert title label
  open fileprivate(set) var alertTitle: UILabel!
  
  /// Get the alert message label
  open fileprivate(set) var alertMessage: UILabel!
  
  /// Get the alert buttons
  open fileprivate(set) var alertButtons: [PopupAlertButton]!

  /// Invoke alert canceled action when alert controller receives negative notification
  open var alertCanceledAction: (() -> Void)?

  /// Invoke alert selected action when alert controller receives positive notification
  open var alertConfirmedAction: ((Int, String) -> Void)?
  
  // MARK: Private & Internal
  
  /// Content view contains alert title, alert message, and alert buttons
  fileprivate var content: UIView
  
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
    super.init(contentView: content)
    
    titleText = title
    messageText = message
    cancelTitle = dismiss
    itemOptions = options
    
    alertTitle = configureAlertTitle()
    alertMessage = configureAlertMessage()
    alertButtons = configureAlertButtons()
    
    negativeAction = { (popUpInfo) in
      if let action = self.alertCanceledAction {
        action()
      }
    }
    
    positiveAction = { (popUpInfo) in
      if let info = popUpInfo as? (Int, String), let action = self.alertConfirmedAction {
        action(info.0, info.1)
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
  fileprivate func configureAlertTitle() -> UILabel {
    let title = createLabel(alertAppearance.titleFont)
    title.text = titleText

    content.addSubview(title)
    let hs = alertAppearance.horizontalSpace
    let constant = alertAppearance.verticalSpaceBetweenTitleAndTop
    content.bindWith(title, attribute: .top, constant: constant)
    content.bindFrom("H:|-(\(hs))-[title]-(\(hs))-|", views: ["title" : title])
    return title
  }
  
  /**
   Configure alert message view, set text, bind constraints
   
   - returns: Alert message
   */
  fileprivate func configureAlertMessage() -> UILabel {
    let message = createLabel(alertAppearance.messageFont)
    message.text = messageText

    content.addSubview(message)
    let hs = alertAppearance.horizontalSpace
    let constant = alertAppearance.verticalSpaceBetweenTitleAndMessage
    content.bind(message, attribute: .top, to: alertTitle, toAttribute: .bottom, constant: constant)
    content.bindFrom("H:|-(\(hs))-[message]-(\(hs))-|", views: ["message" : message])
    return message
  }
  
  /**
   Configure alert buttons, bind constraints
   
   - returns: Alert buttons
   */
  fileprivate func configureAlertButtons() -> [PopupAlertButton] {
    //let subclass implement
    var buttons = [PopupAlertButton]()
    if hasCancelButton {   //if cancel button was set, set it with cancel style
      let cancelButton = PopupAlertButton(style: .cancel, title: cancelTitle!, appearance: alertAppearance)
      cancelButton.addTarget(self, action: #selector(cancelButtonSelected), for: .touchUpInside)
      content.addSubview(cancelButton)
      buttons.append(cancelButton)
    }
    
    for option in itemOptions {    //set other buttons with plain style
      let button = PopupAlertButton(style: .plain, title: option, appearance: alertAppearance)
      button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
      content.addSubview(button)
      buttons.append(button)
    }
    
    return buttons
  }
  
  // MARK: View Controller life cycle
  
  public final override func viewDidLoad() {
    layoutAlertButtons(at: content, buttons: alertButtons)
    appearance.popupHeight = appearance.fixedHeight == 0 ? calcNecessaryHeight() : appearance.fixedHeight
    appearance.popupWidth = appearance.fixedWidth == 0 ? appearance.popupWidth : appearance.fixedWidth
    super.viewDidLoad()
  }
  
  public final override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    alertCanceledAction = nil
    alertConfirmedAction = nil
  }
  
  /**
   Calculate minimum necessary height to fully display alert controller
   
   - returns: Minimum necessary height of alert controller
   */
  fileprivate func calcNecessaryHeight() -> CGFloat {
    let titleHeight = calcHeightOfAlertTitle() + alertAppearance.verticalSpaceBetweenTitleAndTop
    let messageHeight = calcHeightOfAlertMessage() + alertAppearance.verticalSpaceBetweenTitleAndMessage
    let buttonsHeight = alertAppearance.verticalSpaceBetweenMessageAndButtons + calcHeightOfAlertButtons()
    return (titleHeight + messageHeight + buttonsHeight)
  }

  /**
   Calculate height of alert title
   
   - returns: Height of alert title
   */
  fileprivate func calcHeightOfAlertTitle() -> CGFloat {
    let width = appearance.fixedWidth == 0 ? appearance.popupWidth : appearance.fixedWidth
    return alertTitle.font.sizeOfString(titleText as NSString, constrainedToWidth: Double(width - alertAppearance.horizontalSpace - alertAppearance.horizontalSpace)).height
  }
  
  /**
   Calculate height of alert message
   
   - returns: Height of alert message
   */
  fileprivate func calcHeightOfAlertMessage() -> CGFloat {
    guard let text = messageText else {
      return 0
    }
    let width = appearance.fixedWidth == 0 ? appearance.popupWidth : appearance.fixedWidth
    return alertMessage.font.sizeOfString(text as NSString, constrainedToWidth: Double(width - alertAppearance.horizontalSpace - alertAppearance.horizontalSpace)).height
  }
  
  /**
   Cancel button tapped action
   
   - parameter sender: Cancel button
   */
  func cancelButtonSelected(_ sender: AnyObject) {
    if let popup = content.popup {
      popup.invokeNegativeAction(nil)
    }
  }
  
  /**
   Any alert button selected action
   
   - parameter sender: Selected alert button
   */
  func buttonSelected(_ sender: AnyObject) {
    let button = sender as! UIButton
    let title = button.title(for: UIControlState())!
    let index = itemOptions.index(of: title)!
    content.popup?.invokePositiveAction((index, title))
  }
  
  /**
   Help to create an UILabel
   
   - parameter font: Font of label
   
   - returns: UILabel instance
   */
  fileprivate func createLabel(_ font: UIFont) -> UILabel {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.font = font
    title.textAlignment = .center
    title.numberOfLines = 0
    return title
  }
  
  // MARK: Required method
  
  /**
   Subclass should implement this method to layout alert buttons
   
   - parameter parent:  The container view contains all alert buttons
   - parameter buttons: Alert buttons
   */
  func layoutAlertButtons(at parent: UIView, buttons: [PopupAlertButton]) {}
  
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
public enum PopupAlertButtonStype: Int {
  case plain = 0
  case cancel = 1
}

/// Popup Alert Button
public final class PopupAlertButton: UIButton {
  
  // MARK: Private & Internal
  
  /// Button style
  let style: PopupAlertButtonStype
  
  /// Top separator
  lazy var topSeparator: UIView = {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    return separator
  }()
  
  /// Right separator (Cancel Button only)
  lazy var rightSeparator: UIView = {
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
   
   - parameter style:      Button style
   - parameter title:      Button title
   - parameter appearance: Button appearance
   
   - returns: Alert button
   */
  init(style: PopupAlertButtonStype, title: String, appearance: PopupAlertControllerAppearance?) {
    self.style = style
    super.init(frame: .zero)
    setTitle(title, for: UIControlState())
    setTitleColor(UIColor.black, for: UIControlState())
    translatesAutoresizingMaskIntoConstraints = false
    
    guard let _ = appearance else {return}
    
    if appearance!.enableButtonSeparator {
      topSeparator.backgroundColor = appearance!.buttonSeparatorColor
      addSubview(topSeparator)
      bindFrom("V:|[separator(1)]", views: ["separator": topSeparator])
      bindFrom("H:|[separator]|", views: ["separator": topSeparator])
      
      if style == .cancel {
        rightSeparator.backgroundColor = appearance!.buttonSeparatorColor
        addSubview(rightSeparator)
        bindFrom("H:[separator(1)]|", views: ["separator": rightSeparator])
        bindFrom("V:|[separator]|", views: ["separator": rightSeparator])
      }
    }
    
    switch style {
    case .plain:
      backgroundColor = appearance!.plainButtonBackgroundColor
      titleLabel?.font = appearance!.plainButtonFont
      setTitleColor(appearance!.plainButtonTitleColor, for: UIControlState())
    case .cancel:
      backgroundColor = appearance!.cancelButtonBackgroundColor
      titleLabel?.font = appearance!.cancelButtonFont
      setTitleColor(appearance!.cancelButtonTitleColor, for: UIControlState())
    }
  }
  
  // Init with coder not implemented
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
