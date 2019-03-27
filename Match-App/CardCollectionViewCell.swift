//
//  CardCollectionViewCell.swift
//  Match-App
//
//  Created by Dan Kass on 3/19/19.
//  Copyright © 2019 Couchguy Labs. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        // Keep track of the card that gets passed in
        self.card = card
        
        if card.isMatched == true {
            // If the card has already been match make invisable
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            // If the card has not been matched make visble
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // Determine if the card is in a flipped up state or flipped down state
        if(card.isFlipped == true) {
            // Make sure front is on top
                UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            // Make sure back is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove() {
        // Removed both imagesviews from being visible
        backImageView.alpha = 0
        
        // Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
