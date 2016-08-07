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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CQPopupKit Demo"
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.alertViews.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("option", forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = alertViews[indexPath.row]
        } else {
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "AlertView"
        } else if section == 1 {
            return "ActionSheet"
        } else {
            return ""
        }
    }
    
    @IBAction func optionButtonTapped(sender: AnyObject) {
        let popup = CQPopup()
        popup.appearance.widthMultiplier = 0.9
        popup.appearance.heightMultiplier = 0.9
        popup.animationAppearance.transitionDirection = .TopToBottom
        popup.animationAppearance.transitionStyle = .Bounce
        self.cq_present(popup)
    }
    
}

extension ViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let alertView = CQAlertView(title: "Overwatch", message: nil, dismiss: nil)
                self.cq_present(alertView)
            } else if indexPath.row == 1 {
                let alertView = CQAlertView.init(title: "Overwatch", message: "Traveling to Lijiang Tower", dismiss: nil)
                self.cq_present(alertView)
            } else if indexPath.row == 2 {
                let alertView = CQAlertView.init(title: "Overwatch", message: "Traveling to Lijiang Tower", dismiss: "Ok")
                self.cq_present(alertView)
            } else if indexPath.row == 3 {
                let alertView = CQAlertView.init(title: "Overwatch", message: "Traveling to Lijiang Tower", cancel: "Exit", confirm: "I'm ready!")
                alertView.appearance.enableTouchOutsideToDismiss = false
                self.cq_present(alertView)
            } else if indexPath.row == 4 {
                let alertView = CQAlertView.init(title: "Overwatch", message: "Which hero you want to pick up?", dismiss: "I'll fight by myself", options: ["Solder.76", "Mei", "Hanzo", "Genji", "Ana"])
                
                alertView.alertCanceledAction = {
                    print("Fight by my self!")
                }
                
                alertView.alertSelectedAction = {index, title in
                    print("You picked \(title) @ \(index)")
                }
                
                self.cq_present(alertView)
            }
        }
    }
}

