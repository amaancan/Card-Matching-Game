//
//  ViewController.swift
//  MatchingCardGame
//
//  Created by Amaan on 2018-01-19.
//  Copyright © 2018 amaancan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // BIG GREEN ARROW from my controller --> model: so it can talk to model
    //  "Hey Concentration Game Model, make a game with x pairs of cards, based on what user told me"
    //  MARK: Q: Concentration is a class since only one game obj, Card is a struct since multiple card obj?
    
    // Often would want out model to be non-private since you give a model to VC and it displays it. Private because numberOfPairsOfCards in the game is tied to UI. We'd also have to make sth non-private that specifies the # of cardButtons. ?
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // Class and things outside of class can GET it but no one can SET it.
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 { // init of var doesn't trigger didSet
        //Property observer which listens for change in the variable —> runs code (update UI displaying the variable)
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey: Any]? = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.gray
        ]
         let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    //Outlets and Actions are almost always 'private' since internal implementation of controlling UI
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]! //Outlet collection (connection): an array of that type of UI objs
    
    //Copying a button (or any UI obj in IB) will also copy over it's connected IBActions and IBOutlets. Be careful! Don't add another IBAction --> 1 button w/ 2 IBAction calls.
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber) // instead of flipping here, give that resp to model/game
            updateViewFromModel() // tell view to stay in sync with the model/game
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            // @ this point I've got the button (UI) and the associated Card model
            if card.isFaceUp {
                //MARK: Q: Why use set tile function instead of changing value of title var? Like next line or 20: for label.text = "..."
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            } 
        }
        
    }
    
    // Can't make it 'internal' since we consume this var   
    private var emojiChoices = "🎃🦇🍎😱🙀😈👻🍬"

    // Can't make it 'internal' since building dictionary on the fly
    var emoji = [Card: String]()
    
    func emoji(for card: Card) -> String {
        // Just in time loading up of emoji dictionary
        if emoji[card] == nil, emojiChoices.count > 0 { // Looking sth up in a dictionary returns an optional
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?" //Nil-coelscing: return this, but if it's nil, return this
    }
}

extension Int {
    // Returns a random number between 0 and the Int (exsluding the Int) by tapping into this computed var's getter.
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self))) //self is for instance not type here
        } else if self < 0 { // Won't crash if called by a negative Int now.
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
