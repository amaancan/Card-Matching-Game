//
//  Card.swift
//  MatchingCardGame
//
//  Created by Amaan on 2018-01-19.
//  Copyright © 2018 amaancan. All rights reserved.
//

import UIKit

//It's the model of a unique Card w/o emoji displayed in UI
//  1. Am I face up
//  2. Am I matched up and therfore kicked out of the game
//  3. My unique ID
//  4. TYPE ONLY, NOT OBJ - make an ID & hold onto next ID# to be given to next init()
//  5. init() a Card - call unique ID func from TYPE to use in making obj

struct Card {
    
    // Didn't put associated emoji since model needs to be UI independent
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1 // can access static vars in static func w/o referring to Card.identifierFactory
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}