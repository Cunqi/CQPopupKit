//
//  UIView+Calculation.swift
//  CQPopupViewController
//
//  Created by Cunqi.X on 8/4/16.
//  Copyright © 2016 Cunqi Xiao. All rights reserved.
//

import UIKit

extension UIView {
  /// if the view is a subview in CQPopupContainer, use this property to get  the CQPopup
  public var popup: CQPopup? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.nextResponder()
      if let popup = parentResponder as? CQPopup {
        return popup
      }
    }
    return nil
  }

  func bindWith(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, multiplier: CGFloat = 1.0, constant: CGFloat = 1.0) -> UIView {
    addConstraint(buildConstraintWith(item, attribute: attribute, relation: relation, multiplier: multiplier, constant: constant))
    return self
  }
  
  func buildConstraintWith(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, multiplier: CGFloat = 1.0, constant: CGFloat = 1.0) -> NSLayoutConstraint {
    return buildConstraintBetween((view: item, attribute: attribute), and: (view: self, attribute: attribute), relation: relation, multiplier: multiplier, constant: constant)
  }
  
  
  func bindBetween(item: (view: UIView, attribute: NSLayoutAttribute), and another: (view: UIView?, attribute: NSLayoutAttribute), relation: NSLayoutRelation = .Equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> UIView {
    addConstraint(buildConstraintBetween(item, and: another, relation: relation, multiplier: multiplier, constant: constant))
    return self
  }
  
  func buildConstraintBetween(item: (view: UIView, attribute: NSLayoutAttribute), and another: (view: UIView?, attribute: NSLayoutAttribute), relation: NSLayoutRelation = .Equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {
    return NSLayoutConstraint.init(item: item.view, attribute: item.attribute, relatedBy: relation, toItem: another.view, attribute: another.attribute, multiplier: multiplier, constant: constant)
  }
  
  func bindFrom(format: String, views: [String: UIView], options: NSLayoutFormatOptions = NSLayoutFormatOptions.init(rawValue: 0), metrics: [String: AnyObject]? = nil) -> UIView {
    addConstraints(buildConstraintsFrom(format, views: views, options: options, metrics: metrics))
    return self
  }
  
  func buildConstraintsFrom(format: String, views: [String: UIView], options: NSLayoutFormatOptions = NSLayoutFormatOptions.init(rawValue: 0), metrics: [String: AnyObject]? = nil) -> [NSLayoutConstraint] {
    return NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views)
  }
  
  func fillSubview(subView: UIView) {
    subView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subView)
    let views = ["subView": subView]
    bindFrom("H:|[subView]|", views: views).bindFrom("V:|[subView]|", views: views).layoutIfNeeded()
  }
}

extension UIViewController {
  public func cq_present(viewControllerToPresent: CQPopup, completion: (() -> Void)? = nil) {
    viewControllerToPresent.view.backgroundColor = UIColor.clearColor()
    definesPresentationContext = true
    presentViewController(viewControllerToPresent, animated: true, completion: completion)
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
  }
}

extension UIFont {
  func sizeOfString (string: NSString, constrainedToWidth width: Double) -> CGSize {
    return string.boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
                                       options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                       attributes: [NSFontAttributeName: self],
                                       context: nil).size
  }
}
