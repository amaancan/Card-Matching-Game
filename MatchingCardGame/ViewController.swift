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
    //  "Hey Concentration Game Model, make a game with 5 pairs of cards, based on what user told me"
    //  MARK: Q: Concentration is a class since only one game obj, Card is a struct since multiple card obj?
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        //Property observer which listens for change in the variable —> runs code (update UI displaying the variable)
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]! //Outlet collection (connection): an array of that type of UI objs
    
    //Copying a button (or any UI obj in IB) will also copy over it's connected IBActions and IBOutlets. Be careful! Don't add another IBAction --> 1 button w/ 2 IBAction calls.
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber) // instead of flipping here, give that resp to model/game
            updateViewFromModel() // tell view to stay in sync with the model/game
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
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
    
    var emojiChoices = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"]
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        // Just in time loading up of emoji dictionary
        if emoji[card.identifier] == nil, emojiChoices.count > 0 { // Looking sth up in a dictionary returns an optional
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count - 1)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?" //Nil-coelscing: return this, but if it's nil, return this
    }

}

