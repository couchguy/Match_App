//
//  File.swift
//  Match-App
//
//  Created by Dan Kass on 3/19/19.
//  Copyright © 2019 Couchguy Labs. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        // Declare an Array to store already generated numbers
        var generatedNumbersArray = [Int]()
        
        // Declare an Array to store generated cards
        var generatedCardsArray = [Card]()
        
        // Randoly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            // Get Random Number
            let randomNumber = arc4random_uniform(13) + 1
            
            // Ensure the Random number isn't already used
            if !generatedNumbersArray.contains(Int(randomNumber)) {

                // Log the Number
                print(randomNumber)
                
                // Store the number into the array
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card Object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                // Create the second card Object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
            
        }
        
        // Randomize the array
        generatedCardsArray.shuffle()
        
        // Return the array
        return generatedCardsArray
    }
}
