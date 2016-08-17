//
//  ViewController.swift
//  CQPopupKit
//
//  Created by cunqi on 08/06/2016.
//  Copyright (c) 2016 cunqi. All rights reserved.
//

import UIKit
import CQPopupKit

class ViewController: UITableViewController {
  
  let alertViews = [
    "AlertView - Title",
    "AlertView - Title & message",
    "AlertView - Cancel",
    "AlertView - Cancel & Confirm & Modal enabled",
    "AlertView - Multiple Choose & selection response"
  ]
  
  let actionSheets = [
    "ActionSheet - Basic"
  ]
  
  let popupDialogs = [
    "PopupDialogue - Basic",
    "PopupDialogue - DatePicker",
    "PopupDialogue - SinglePicker",
    "PopupDialogue - MultiPicker"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "CQPopupKit Demo"
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return alertViews.count
    } else if section == 1 {
      return actionSheets.count
    } else {
      return popupDialogs.count
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("option", forIndexPath: indexPath)
    if indexPath.section == 0 {
      cell.textLabel?.text = alertViews[indexPath.row]
    } else if indexPath.section == 1 {
      cell.textLabel?.text = actionSheets[indexPath.row]
    } else if indexPath.section == 2 {
      cell.textLabel?.text = popupDialogs[indexPath.row]
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "AlertView"
    } else if section == 1 {
      return "ActionSheet"
    } else if section == 2{
      return "PopupDialogue"
    }
    return nil
  }
  
  @IBAction func optionButtonTapped(sender: AnyObject) {
    let popup = Popup()
    popup.appearance.widthMultiplier = 0.9
    popup.appearance.heightMultiplier = 0.9
    popup.animationAppearance.transitionDirection = .topToBottom
    popup.animationAppearance.transitionStyle = .bounce
    self.popUp(popup)
  }
  
}

extension ViewController {
  // FIX Double click on table cell
  // http://stackoverflow.com/questions/20320591/uitableview-and-presentviewcontroller-takes-2-clicks-to-display
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      var alertView: CQAlertView!
      if indexPath.row == 0 {
         alertView = CQAlertView(title: "Overwatch", message: nil, dismiss: nil)
      } else if indexPath.row == 1 {
        alertView = CQAlertView(title: "Overwatch", message: "Traveling to Lijiang Tower", dismiss: nil)
      } else if indexPath.row == 2 {
        alertView = CQAlertView(title: "Overwatch", message: "Traveling to Lijiang Tower", dismiss: "Ok")
      } else if indexPath.row == 3 {
        alertView = CQAlertView(title: "Overwatch", message: "Traveling to Lijiang Tower", cancel: "Exit", confirm: "I'm ready!")
        alertView.appearance.enableTouchOutsideToDismiss = false
      } else if indexPath.row == 4 {
        alertView = CQAlertView(title: "Overwatch", message: "Which hero you want to pick up?", dismiss: "I'll fight by myself", options: ["Solder.76", "Mei", "Hanzo", "Genji", "Ana"])
        alertView.alertCanceledAction = {
          print("Fight by my self!")
        }
        alertView.alertSelectedAction = {index, title in
          print("You picked \(title) @ \(index)")
        }
      }
      dispatch_async(dispatch_get_main_queue(), {
        self.popUp(alertView)
      })
    } else if indexPath.section == 1 {
      if indexPath.row == 0 {
        let actionSheet = CQActionSheet(title: "Overwatch", message: "Which hero you want to pick up?", dismiss: "I'll fight by myself", options: ["Solder.76", "Mei", "Hanzo", "Genji", "Ana"])
        
        actionSheet.alertCanceledAction = {
          print("Fight by my self!")
        }
        
        actionSheet.alertSelectedAction = {index, title in
          print("You picked \(title) @ \(index)")
        }
        
        dispatch_async(dispatch_get_main_queue(), {
          self.popUp(actionSheet)
        })
      }
    } else if indexPath.section == 2 {
      if indexPath.row == 0 {
        let dialogue = PopupDialogue(title: "Empty Picker", contentView: UIView(),  positiveAction: nil, negativeAction: nil)
        dispatch_async(dispatch_get_main_queue(), {
          self.popUp(dialogue)
        })
      } else if indexPath.row == 1 {
        let dialogue = CQDatePicker(title: "Date Picker", mode: .Time)
        dialogue.appearance.widthMultiplier = 1.0
        dialogue.appearance.heightMultiplier = 0.4
        dialogue.appearance.viewAttachedPosition = .bottom
        dialogue.animationAppearance.transitionDirection = .bottomToTop
        
        dialogue.confirmAction = {date in
          let formatter = NSDateFormatter()
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          print(formatter.stringFromDate(date))
        }
        
        dispatch_async(dispatch_get_main_queue(), {
          self.popUp(dialogue)
        })
      } else if indexPath.row == 2 {
        let dialogue = CQPicker(title: "Single Picker", options: ["Mercy", "Anna", "Lucio", "Waston", "Bastion"])
        dialogue.confirmAction = { (options) in
          print(options)
        }
        
        dispatch_async(dispatch_get_main_queue(), {
          self.popUp(dialogue)
        })
      }
    }
  }
}

