//
//  CustomTextField.swift
//  LMS-MVP
//
//  Created by Arvind Vlk on 25/07/17.
//  Copyright © 2017 LMS-MVP. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyNextField: String = ""

extension UITextField {
    
    func addToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .darkGray
        let lButton = ActionButton(type: .custom)
        lButton.setTitle(AppStrings.Title.done, for: .normal)
        lButton.titleLabel?.font = R.font.balqis(size: 14)
        lButton.setTitleColor(.darkGray, for: .normal)
        lButton.layer.cornerRadius = 5
        lButton.backgroundColor = UIColor.clear
        lButton.addTarget(self, action: #selector(donePressed), for: [.touchUpInside])
        lButton.sizeToFit()
        let lBarButton = UIBarButtonItem(customView: lButton)

        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, lBarButton], animated: false)
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
        //lButton.setupButton()
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
    
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

