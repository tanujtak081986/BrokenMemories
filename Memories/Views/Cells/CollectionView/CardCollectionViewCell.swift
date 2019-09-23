//
//  CardCollectionViewCell.swift
//  Memories
//
//  Created by tanuj tak on 5/10/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import UIKit
import SDWebImage
import GhostTypewriter

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgContainerView: CustomView!
    @IBOutlet weak var cardBackgroundImage: UIImageView!
    @IBOutlet weak var cardTitle: TypewriterLabel!
    @IBOutlet weak var cardMessage: TypewriterLabel!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var cardDetailsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBlurView: UIVisualEffectView!
    @IBOutlet weak var loaderView: VDSCircleAnimation!
    
    private let initialConstraint : CGFloat = -1000
    private var lastGestureVelocity: CGPoint = .zero
    private var direction = panDirection.up
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    enum panDirection {
        case up
        case down
    }
    
    var card : MemoryCard! {
        didSet {
            cardTitle.text = card.title
            cardMessage.text = card.message.replacingOccurrences(of: "\\n", with: "\n")
            cardMessage.alpha = 0
            cardTitle.alpha = 0
            
            cardBackgroundImage.alpha = 0
            loaderView.isHidden = false
            if let urlString = card.photoUrl, let url = URL(string: urlString) {
                cardBackgroundImage.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages) { (image, error, type, url) in
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.loaderView.isHidden = true
                        self.cardDetailsView.alpha = 1
                        self.cardBackgroundImage.alpha = 1
                    })
                    self.perform(#selector(self.loadDetails), with: nil, afterDelay: 0.10)
                    
                }
            }
        }
    }
    
    private func setupCell() {
        cardDetailsViewBottomConstraint.constant = initialConstraint
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(cardDetailsViewDragged(_:)))
        cardDetailsView.isUserInteractionEnabled = true
        cardDetailsView.addGestureRecognizer(dragGesture)
        
        //card view top rounded corners only
        cardDetailsView.clipsToBounds = true
        cardDetailsView.layer.cornerRadius = 40
        cardDetailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //Load the details on the view after the image has loaded.
    @objc
    private func loadDetails() {
        self.animateCardDetailsView()
    }
    
    override func prepareForReuse() {
        cardBackgroundImage.image = nil
    }
}

extension CardCollectionViewCell {
    
    //animate the card, image for display
    private func animateCardDetailsView() {
        
        cardDetailsViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.layoutIfNeeded()
        }, completion: { (completed) in
            if completed {
                self.cardTitle.startTypewritingAnimation {
                    self.cardMessage.alpha = 1
                    self.cardMessage.startTypewritingAnimation(completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        self.animateViewWithOffset(-(self.cardMessage.frame.size.height + 20),direction: .down)
                        })
                    })
                }
                UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut, animations: {
                    self.cardTitle.alpha = 1
                }, completion: nil)
            }
        })
    }
    
    //this method animates the cardview when the message typing animation is finished
    private func animateViewWithOffset(_ offset: CGFloat, direction: panDirection) {
        cardDetailsViewBottomConstraint.constant = offset
        
        UIView.animate(withDuration: 0.55, delay: 0.10, usingSpringWithDamping: 0.75, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            if(direction == .down) {
                self.cardMessage.alpha = 0
                    UIView.animate(withDuration: 1, animations:{
                        self.imageBlurView.alpha = 0
                    })
                self.cardDetailsView.alpha = 0.40
            } else {
                    UIView.animate(withDuration: 1, animations:{
                        self.imageBlurView.alpha = 0.50
                    })
                self.cardMessage.alpha = 1
                self.cardDetailsView.alpha = 1
            }
            self.layoutIfNeeded()
        }) { (completed) in }
    }
    
    //pan gesture for the user to drag the cardview up and down to show/hide accordingly
    @objc
    private func cardDetailsViewDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        var offset: CGFloat = 0
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let velocity = gestureRecognizer.velocity(in: cardDetailsView)
            if(velocity.y > 0) {
                direction = .down
                offset = -(cardMessage.frame.size.height + 20)
            } else {
                direction = .up
                offset = 0
            }
            
            animateViewWithOffset(offset, direction: direction)
        }
    }
}
