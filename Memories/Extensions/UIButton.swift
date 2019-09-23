//
//  UIButton.swift
//  LMS-MVP
//
//  Created by Arvind Valaki on 05/01/18.
//  Copyright © 2018 LMS-MVP. All rights reserved.
//

import UIKit

@IBDesignable class ActionButton : UIButton {

    var touchUp: ((_ button: UIButton) -> ())?
    var longPress: ((_ gesture: UILongPressGestureRecognizer) -> ())?

    override func awakeFromNib() {
        setupButton()
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                backgroundColor = .green
            }
            else {
                backgroundColor = .lightGray
            }
            super.isSelected = newValue
        }
    }
    
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

    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }

    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }

    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    func setupButton() {
        //this is my most common setup, but you can customize to your liking
        addTarget(self, action: #selector(touchUp(sender:)), for: [.touchUpInside])
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        gesture.numberOfTouchesRequired = 1
        gesture.minimumPressDuration = 1
        addGestureRecognizer(gesture)
        
    }
    
    @objc func longPressed(gesture:UILongPressGestureRecognizer) {
        longPress?(gesture)
    }
    
    @objc func touchUp(sender: UIButton) {
        touchUp?(sender)
    }
    
}


