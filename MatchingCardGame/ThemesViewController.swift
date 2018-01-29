//
//  ThemesViewController.swift
//  MatchingCardGame
//
//  Created by Amaan on 2018-01-28.
//  Copyright © 2018 amaancan. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    let themes = [
        "Sports": "⚽️🏀🏅⛷🏏🏓⛳️🏆🥋🏂🏑🏒🏉🎾⚾️",
        "Animals": "🐶🦊🦁🐸🐯🐣🐳🐠🦉🐹🐭🐱🙈🐧🐔",
        "Food": "🍎🥐🌶🍆🥑🍒🍑🍅🍇🍉🍌🍋🍏🍊🥕"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseTheme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                }
            }
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
    }
    

}
