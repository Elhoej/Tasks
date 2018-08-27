//
//  AppearanceHelper.swift
//  Tasks
//
//  Created by Simon Elhoej Steinmejer on 27/08/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

extension UIColor
{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}

extension UINavigationController
{
    open override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}

enum Appearance
{
    static let backgroundColor = UIColor.rgb(red: 0, green: 23, blue: 31)
    static let myBlueColor = UIColor.rgb(red: 0, green: 168, blue: 232)
    
    static func setupAppearance()
    {
        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Montserrat-Regular", size: 20)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Montserrat-Regular", size: 30)!]
        
        UILabel.appearance().textColor = .white
        
        UITextField.appearance().tintColor = myBlueColor
        UITextField.appearance().keyboardAppearance = .dark
        
        UITextView.appearance().tintColor = myBlueColor
        
        UISegmentedControl.appearance().tintColor = myBlueColor
        
        UITableViewCell.appearance().backgroundColor = backgroundColor
    }
    
    static func appFont(with textStyle: UIFontTextStyle, size: CGFloat) -> UIFont
    {
        let font = UIFont(name: "Montserrat-Regular", size: size)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font!)
    }
}









