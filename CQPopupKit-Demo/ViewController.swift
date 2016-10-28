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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return alertViews.count
    } else if section == 1 {
      return actionSheets.count
    } else {
      return popupDialogs.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath)
    if (indexPath as NSIndexPath).section == 0 {
      cell.textLabel?.text = alertViews[(indexPath as NSIndexPath).row]
    } else if (indexPath as NSIndexPath).section == 1 {
      cell.textLabel?.text = actionSheets[(indexPath as NSIndexPath).row]
    } else if (indexPath as NSIndexPath).section == 2 {
      cell.textLabel?.text = popupDialogs[(indexPath as NSIndexPath).row]
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "AlertView"
    } else if section == 1 {
      return "ActionSheet"
    } else if section == 2{
      return "PopupDialogue"
    }
    return nil
  }
  
  @IBAction func optionButtonTapped(_ sender: AnyObject) {
    let popup = Popup()
    popup.appearance.widthMultiplier = 0.9
    popup.appearance.heightMultiplier = 0.9
    popup.animationAppearance.transitionDirection = .leftReverse
    popup.animationAppearance.transitionStyle = .bounce
    self.popUp(popup)
  }
  
}

extension ViewController {
  // FIX Double click on table cell
  // http://stackoverflow.com/questions/20320591/uitableview-and-presentviewcontroller-takes-2-clicks-to-display
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == 0 {
      var alertView: CQAlertView!
      if (indexPath as NSIndexPath).row == 0 {
        alertView = CQAlertView(title: "Overwatch", message: nil, dismiss: nil)
      } else if (indexPath as NSIndexPath).row == 1 {
        alertView = CQAlertView(title: "Overwatch", message: "Traveling to Lijiang Tower", dismiss: nil)
      } else if (indexPath as NSIndexPath).row == 2 {
        alertView = CQAlertView(title: "Overwatch", message: "Traveling to Lijiang Tower", dismiss: "Ok")
      } else if (indexPath as NSIndexPath).row == 3 {
        alertView = CQAlertView(title: "Overwatch", message: "Traveling to Lijiang Tower", cancel: "Exit", confirm: "I'm ready!")
        alertView.appearance.enableTouchOutsideToDismiss = false
      } else if (indexPath as NSIndexPath).row == 4 {
        alertView = CQAlertView(title: "Overwatch", message: "Which hero you want to pick up?", dismiss: "I'll fight by myself", options: ["Solder.76", "Mei", "Hanzo", "Genji", "Ana"])
        alertView.alertCanceledAction = {
          print("Fight by my self!")
        }
        alertView.alertConfirmedAction = {index, title in
          print("You picked \(title) @ \(index)")
        }
      }
      DispatchQueue.main.async(execute: {
        self.popUp(alertView)
      })
    } else if (indexPath as NSIndexPath).section == 1 {
      if (indexPath as NSIndexPath).row == 0 {
        let actionSheet = CQActionSheet(title: "Overwatch", message: "Which hero you want to pick up?", dismiss: "I'll fight by myself", options: ["Solder.76", "Mei", "Hanzo", "Genji", "Ana"])
        
        actionSheet.alertCanceledAction = {
          print("Fight by my self!")
        }
        
        actionSheet.alertConfirmedAction = {index, title in
          print("You picked \(title) @ \(index)")
        }
        
        DispatchQueue.main.async(execute: {
          self.popUp(actionSheet)
        })
      }
    } else if (indexPath as NSIndexPath).section == 2 {
      if (indexPath as NSIndexPath).row == 0 {
        let dialogue = PopupDialogue(title: "Empty Picker", contentView: UIView(),  positiveAction: nil, negativeAction: nil)
        DispatchQueue.main.async(execute: {
          self.popUp(dialogue)
        })
      } else if (indexPath as NSIndexPath).row == 1 {
        let dialogue = CQDatePicker(title: "Date Picker", mode: .time)
        dialogue.appearance.widthMultiplier = 1.0
        dialogue.appearance.heightMultiplier = 0.4
        dialogue.appearance.viewAttachedPosition = .bottom
        dialogue.animationAppearance.transitionDirection = .bottomToTop
        
        dialogue.confirmAction = {date in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          print(formatter.string(from: date))
        }
        
        DispatchQueue.main.async(execute: {
          self.popUp(dialogue)
        })
      } else if (indexPath as NSIndexPath).row == 2 {
        let dialogue = CQPicker(title: "Single Picker", options: ["Mercy", "Anna", "Lucio", "Waston", "Bastion"])
        dialogue.confirmAction = { (options) in
          print(options)
        }
        
        DispatchQueue.main.async(execute: {
          self.popUp(dialogue)
        })
      } else if (indexPath as NSIndexPath).row == 3 {
        let dialogue = CQPicker(title: "Multi Picker", multiOptions: [["Lijiang Tower", "Route 66", "Dorado"],  ["Mercy", "Anna", "Lucio", "Waston", "Bastion"]], confirmText: "Fight")
        dialogue.confirmAction = { (options) in
          print(options)
        }
        
        DispatchQueue.main.async(execute: {
          self.popUp(dialogue)
        })
      }
    }
  }
}

