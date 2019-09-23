//
//  ProgressButton.swift
//  Lockout
//
//  Created by tanuj tak on 2/22/19.
//  Copyright © 2019 LockoutUSA. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {
    
    var fillBar : UIView!
    var fillWidthConstraint : NSLayoutConstraint!
    var timer : Timer!
    var pressStartTime: TimeInterval = 0.0
    var longPress : (()->())?
    var touchUp : (()->())?
    var disableLongPress = false
    var progressCompleted = false
    var touchDuration = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
        initConstraints()
    }
    
    func initViews() {
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
//        self.backgroundColor = UIColor.red
        
        
        fillBar = UIView()
        fillBar.backgroundColor = .white
        fillBar.layer.opacity = 0.55
        
        self.addSubview(fillBar)
        
        addTarget(self, action: #selector(touchUp(sender:)), for: [.touchUpInside])
        
        let gestureRecognizer = UILongPressGestureRecognizer()
        gestureRecognizer.minimumPressDuration = 0.2
        gestureRecognizer.addTarget(self, action: #selector(handleLongPress(gestureReconizer:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func initConstraints(){
        fillBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views : [String : Any] = ["fillbar": fillBar]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[fillbar]|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[fillbar]|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: views))
        
        fillWidthConstraint = NSLayoutConstraint.init(item: fillBar, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([fillWidthConstraint])
    }
    
    func setPercentage(percent : CGFloat, animated : Bool){
        var duration = 0.0
        
        if animated{
            duration = 0.2
        }
        self.fillWidthConstraint.constant = self.bounds.size.width * percent
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            
        }
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if disableLongPress {
            return
        }
        switch gestureReconizer.state {
        case .began:
            progressCompleted = false
            pressStartTime = NSDate.timeIntervalSinceReferenceDate
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerChanged), userInfo: nil, repeats: true)
        case.ended :
            timer.invalidate()
            if !progressCompleted{
                setPercentage(percent: 0.0, animated: true)
            }
        default:
            break
            
        }
        
    }
    
    
    @objc func timerChanged(){
        let duration = NSDate.timeIntervalSinceReferenceDate - pressStartTime
        let progress = duration/touchDuration
        setPercentage(percent: CGFloat(progress), animated: true)
        print("Duration : \(duration), Progress : \(progress)")
        if progress >= 1 {
            print("Progress : \(progress)")
            timer.invalidate()
            progressCompleted = true
            longPress?()
            setPercentage(percent: 0.0, animated: false)
        }
    }
    
    @objc func touchUp(sender: UIButton) {
        touchUp?()
    }

}
