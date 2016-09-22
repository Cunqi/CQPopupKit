//
//  UIView+Calculation.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/4/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

extension UIView {
  /// if the view is a subview in PopupContainer, use this property to get  the CQPopup, otherwise, nil
  public var popup: Popup? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let popup = parentResponder as? Popup {
        return popup
      }
    }
    return nil
  }
  
  // MARK: convenience method for constraints binding
  
  func bindWith(_ item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0) {
    addConstraint(buildConstraintWith(item, attribute: attribute, relation: relation, multiplier: multiplier, constant: constant))
  }
  
  func buildConstraintWith(_ item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
    return bindConstraint(item, attribute: attribute, to: self, toAttribute: attribute, withRelation: relation, multiplier: multiplier, constant: constant)
  }
  
  func bind(_ item: UIView, attribute: NSLayoutAttribute, to toView: UIView?, toAttribute: NSLayoutAttribute? = nil, withRelation relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0) {
    addConstraint(bindConstraint(item, attribute: attribute, to: toView, toAttribute: toAttribute, withRelation: relation, multiplier: multiplier, constant: constant))
  }
  
  func bindConstraint(_ item: UIView, attribute: NSLayoutAttribute, to toView: UIView?, toAttribute: NSLayoutAttribute? = nil, withRelation relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
    let toAttr = toAttribute == nil ? attribute : toAttribute!
    return NSLayoutConstraint.init(item: item, attribute: attribute, relatedBy: .equal, toItem: toView, attribute: toAttr, multiplier: multiplier, constant: constant)
  }
  
  
  func bindFrom(_ format: String, views: [String: UIView], options: NSLayoutFormatOptions = NSLayoutFormatOptions.init(rawValue: 0), metrics: [String: Any]? = nil) {
    addConstraints(buildConstraintFrom(format, views: views, options: options, metrics: metrics))
  }
  
  func buildConstraintFrom(_ format: String, views: [String: UIView], options: NSLayoutFormatOptions = NSLayoutFormatOptions.init(rawValue: 0), metrics: [String: Any]? = nil) -> [NSLayoutConstraint] {
    return NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
  }
  
  func fillWithSubview(_ subView: UIView) {
    subView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subView)
    let views = ["subView": subView]
    bindFrom("H:|[subView]|", views: views)
    bindFrom("V:|[subView]|", views: views)
    layoutIfNeeded()
  }
}

extension UIViewController {
  /**
   Ask current view controller to pop up the popup view
   
   - parameter popup:      popup with custom view
   - parameter completion: completion handler
   */
  public func popUp(_ popup: Popup, completion: (() -> Void)? = nil) {
    popup.view.backgroundColor = UIColor.clear
    definesPresentationContext = true
    present(popup, animated: true, completion: completion)
  }
  
  func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
}

extension UIFont {
  func sizeOfString (_ string: NSString, constrainedToWidth width: Double) -> CGSize {
    return string.boundingRect(with: CGSize(width: width, height: DBL_MAX),
                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                       attributes: [NSFontAttributeName: self],
                                       context: nil).size
  }
}
