//
//  Concentration.swift
//  MatchingCardGame
//
//  Created by Amaan on 2018-01-19.
//  Copyright © 2018 amaancan. All rights reserved.
//

import Foundation

//It's the game logic:
//  1. holds all the cards
//  2. which on is currently face up
//  3. what to do when a card is chosen; called by VC
//  4. init - set up a new game (list of Cards) given the # of pairs

class Concentration {
    
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched { // Ignore a tapped card that's already been matched
            // 1. No cards are face up --> flip this tapped card up
            // 2. 2 Cards are faced up (matching or not matching) --> Flip both cards face down
            // 3. 1 card is face up --> see if their IDs are equal
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil    // not one and only ...
            } else {
                // 2 & 3) either no card or two cards face up
                for flipdownIndex in cards.indices {
                    cards[flipdownIndex].isFaceUp = false // flip down every card on the board
                }
                cards[index].isFaceUp = true // turn this tapped card face up
                indexOfOneAndOnlyFaceUpCard = index // this is the index of the card which is face up
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
