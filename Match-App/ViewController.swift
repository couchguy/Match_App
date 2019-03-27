//
//  ViewController.swift
//  Match-App
//
//  Created by Dan Kass on 3/18/19.
//  Copyright © 2019 Couchguy Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Float = 30 * 1000 //10 seconds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the getCards Method of the Cards Model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Create Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed(){
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set Label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When Timer reaches 0
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards left
            checkGameEnded()
        }
    }

    // MARK: - UICollectionView Protocal Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collectionview is trying to display
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time left
        if milliseconds <= 0 {
            return
        }
        
        // Get Cell user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get Card user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            // Flip the cell
            card.isFlipped = true
            cell.flip()
           SoundManager.playSound(.flip)
            
            // Determine if its's the first card or second card that's flipped over
            if firstFlippedCardIndex == nil {
                // This is the first Card being flipped
                firstFlippedCardIndex = indexPath
                
            } else {
                // The is the second card being flipped
                
                // Perform the matching logic
                checkForMatches(indexPath)
            }
        }
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the tow cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            // It's a Match
            
            SoundManager.playSound(.match)
            
            // Set the statuss of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check for any cards left unmatched
            checkGameEnded()
            
            
        } else {
            // It's not a match
            
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell collection to reload the cell of the first card if it is nill
        if cardOneCell  == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset propertiy that tracks first flipped card
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Messaing variables
        var title = ""
        var message = ""
        
        if isWon == true {
            // If not user has won! stop timer
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congradulations!"
            message = "You've won"
            
        } else {
            // If there are unmatched cards, check if timer has time left
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show win/lose messaging
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
 }

