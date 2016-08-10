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
            return self.cancelTitle != nil
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
        self.content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        super.init(contentView: self.content, negativeAction: nil, positiveAction: nil)
        
        self.titleText = title
        self.messageText = message
        self.cancelTitle = dismiss
        self.itemOptions = options
        
        self.alertTitle = self.configureAlertTitle()
        self.alertMessage = self.configureAlertMessage()
        self.alertButtons = self.configureAlertButtons()
        
        self.negativeAction = {popUpInfo in
            if let action = self.alertCanceledAction {
                action()
            }
        }

        self.positiveAction = {popUpInfo in
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
        let title = self.createLabel(self.alertAppearance.titleFont)
        title.text = self.titleText
        self.content.addSubview(title)
        
        let hs = self.alertAppearance.horizontalSpace
        let constant = self.alertAppearance.verticalSpaceBetweenTitleAndTop
        self.content.bindWith(title, attribute: .Top, constant: constant).bindFrom("H:|-(\(hs))-[title]-(\(hs))-|", views: ["title" : title])
        return title
    }
    
    /**
     Configure alert message view, set text, bind constraints
     
     - returns: Alert message
     */
    private func configureAlertMessage() -> UILabel {
        let message = self.createLabel(self.alertAppearance.messageFont)
        message.text = self.messageText
        self.content.addSubview(message)
        
        let hs = self.alertAppearance.horizontalSpace
        let constant = self.alertAppearance.verticalSpaceBetweenTitleAndMessage
        self.content.bindBetween((view: message, attribute: .Top), and: (view: self.alertTitle, attribute: .Bottom), constant: constant).bindFrom("H:|-(\(hs))-[message]-(\(hs))-|", views: ["message" : message])
        return message
    }
    
    /**
     Configure alert buttons, bind constraints
     
     - returns: Alert buttons
     */
    private func configureAlertButtons() -> [CQPopupAlertButton] {
        //let subclass implement
        var buttons = [CQPopupAlertButton]()
        if self.hasCancelButton {   //if cancel button was set, set it with Cancel style
            let cancelButton = CQPopupAlertButton(style: .Cancel, title: self.cancelTitle!, appearance: self.alertAppearance)
            cancelButton.addTarget(self, action: #selector(cancelButtonSelected), forControlEvents: .TouchUpInside)
            self.content.addSubview(cancelButton)
            buttons.append(cancelButton)
        }
        
        for option in self.itemOptions {    //set other buttons with Plain style
            let button = CQPopupAlertButton(style: .Plain, title: option, appearance: self.alertAppearance)
            button.addTarget(self, action: #selector(buttonSelected), forControlEvents: .TouchUpInside)
            self.content.addSubview(button)
            buttons.append(button)
        }
        return buttons
    }


    // MARK: View Controller life cycle
    
    public final override func viewDidLoad() {
        self.layoutAlertButtons(at: self.content, buttons: self.alertButtons)
        self.appearance.heightMultiplier = self.calcNecessaryHeightMultiplier()
        super.viewDidLoad()
    }
    
    public final override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.alertCanceledAction = nil
        self.alertSelectedAction = nil
    }
    
    /**
     Calculate minimum necessary height to fully display alert controller
     
     - returns: Minimum necessary height of alert controller
     */
    private func calcNecessaryHeightMultiplier() -> CGFloat {
        let titleHeight = self.calcHeightOfAlertTitle() + self.alertAppearance.verticalSpaceBetweenTitleAndTop
        let messageHeight = self.calcHeightOfAlertMessage() + alertAppearance.verticalSpaceBetweenTitleAndMessage
        let buttonsHeight = alertAppearance.verticalSpaceBetweenMessageAndButtons + self.calcHeightOfAlertButtons()
        return (titleHeight + messageHeight + buttonsHeight) / UIScreen.mainScreen().bounds.height
    }
    
    
    /**
     Calculate height of alert title
     
     - returns: Height of alert title
     */
    private func calcHeightOfAlertTitle() -> CGFloat {
        let width = self.appearance.widthMultiplier * UIScreen.mainScreen().bounds.width
        return self.alertTitle.font.sizeOfString(self.titleText, constrainedToWidth: Double(width - self.alertAppearance.horizontalSpace - self.alertAppearance.horizontalSpace)).height
    }
    
    /**
     Calculate height of alert message
     
     - returns: Height of alert message
     */
    private func calcHeightOfAlertMessage() -> CGFloat {
        guard let text = self.messageText else {
            return 0
        }
        let width = self.appearance.widthMultiplier * UIScreen.mainScreen().bounds.width
        return self.alertMessage.font.sizeOfString(text, constrainedToWidth: Double(width - self.alertAppearance.horizontalSpace - self.alertAppearance.horizontalSpace)).height
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
        let index = self.itemOptions.indexOf(title)!
        CQPopup.sendPopupPositive([self.selectedIndex: index, self.selectedTitle:title])
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
            self.rightSeparator.alpha = newValue ? 1.0 : 0.0
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
        self.setTitle(title, forState: .Normal)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let _ = appearance else {return}
        
        if appearance!.enableButtonSeparator {
            self.topSeparator.backgroundColor = appearance!.buttonSeparatorColor
            self.addSubview(self.topSeparator)
            self.bindFrom("V:|[separator(1)]", views: ["separator": self.topSeparator]).bindFrom("H:|[separator]|", views: ["separator": self.topSeparator])
            
            if self.style == .Cancel {
                self.rightSeparator.backgroundColor = appearance!.buttonSeparatorColor
                self.addSubview(self.rightSeparator)
                
                self.bindFrom("H:[separator(1)]|", views: ["separator": self.rightSeparator]).bindFrom("V:|[separator]|", views: ["separator": self.rightSeparator])
            }
        }
        
        switch self.style {
        case .Plain:
            self.backgroundColor = appearance!.plainButtonBackgroundColor
            self.titleLabel?.font = appearance!.plainButtonFont
            self.setTitleColor(appearance!.plainButtonTitleColor, forState: .Normal)
        case .Cancel:
            self.backgroundColor = appearance!.cancelButtonBackgroundColor
            self.titleLabel?.font = appearance!.cancelButtonFont
            self.setTitleColor(appearance!.cancelButtonTitleColor, forState: .Normal)
        }
    }

    // Init with coder not implemented
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}