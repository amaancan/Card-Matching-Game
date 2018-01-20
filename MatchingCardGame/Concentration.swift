//
//  Concentration.swift
//  MatchingCardGame
//
//  Created by Amaan on 2018-01-19.
//  Copyright © 2018 amaancan. All rights reserved.
//

import Foundation

//It's the game logic:
//  1. Holds all the cards
//  2. Knows which card (by it's index) is currently the one and only face up card
//  3. What to do when a card is chosen; func called by VC when user taps the card button
//  4. init - set up a new game (list of Cards) given the # of pairs

class Concentration {
    
    // Outsider like VC can get my cards to display it, but I'm the only one responsible for setting it's properties like isMatched, isFaceUp. Makes it like a 'let' for outsiders.
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // Look at all the cards to see if you find only 1 that's face-up, and return it; else return nil
            var foundFaceUpIndex: Int?
            for index in cards.indices { // It's a sequence of generic type 'countable range'
                if cards[index].isFaceUp {
                    if foundFaceUpIndex == nil {
                        foundFaceUpIndex = index
                    } else {
                        return nil
                    }
                }
            }
            
            return foundFaceUpIndex
        }
        
        set {
            // Turn all cards face-down, except the card at index of newValue
            for index in cards.indices {
                cards[index].isFaceUp = (index ==  newValue) //MARK: Note clever use of brackets to contain a value
            }
        }
    }
    
    // Fundamental API which VC calls
    func chooseCard(at index: Int) {
        if !cards[index].isMatched { // Ignore a tapped card that's already been matched a.k.a out of the game
            
            // THREE POSSIBILE SCENARIOS:
            // 1. 1 card is face up --> see if their IDs are equal
            // 2. No cards are face up --> flip this tapped card up
            // 3. 2 Cards are faced up (matching or not matching) --> Flip both cards face down
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index { // 1) We HAVE only 1 face-up card. And tapped card isn't the same oneAndOnlyFaceUpCard which the user just tapped a few seconds ago.
                
                // Check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true // matched: kicked out of game
                    cards[index].isMatched = true      // matched: kicked out of game
                }
                cards[index].isFaceUp = true
            } else {
                // 2 & 3) Either no card or 2 cards face-up
                indexOfOneAndOnlyFaceUpCard = index // calls setter
            }
            
        }
        // Don't do anything when the tapped card has been matched
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards { // _ since didn't use the specific element we iterated over, just needed a total # of iterations
            let card = Card() // concentration game doesn't care about making unique ids for cards, just wants cards w/ unique ids --> move to Card
            cards += [card, card] // same as cards.append(card) two times
            //*** array and Card types passed as values: 3 Card obj: 1 in 46 and 2 in 47
        }
        //    TODO: Shuffle the cards
    }
    
}
