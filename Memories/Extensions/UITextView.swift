//
//  UITextViewExtenstion.swift
//  LMS-MVP
//
//  Created by Arvind Vlk on 22/08/17.
//  Copyright © 2017 LMS-MVP. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UITextView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    func addToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        let doneButton = UIBarButtonItem(title: AppStrings.Title.done, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }

    func addToolBarWithButton(title:String) -> ActionButton {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        
        let lButton = ActionButton(type: .custom)
        lButton.setTitle(title, for: .normal)
        lButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        lButton.setTitleColor(.darkGray, for: .normal)
        lButton.layer.cornerRadius = 5
        lButton.backgroundColor = UIColor.clear
       // lButton.setupButton()
        lButton.sizeToFit()
        let lBarButton = UIBarButtonItem(customView: lButton)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, lBarButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
        return lButton
    }
    
    @objc func donePressed(){
        self.endEditing(true)
    }
    
    func attributedFromString(text: String) {
        
        let htmlData = NSString(string: text).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        self.attributedText = attributedString
    }
}

