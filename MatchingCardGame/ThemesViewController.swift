//
//  ThemesViewController.swift
//  MatchingCardGame
//
//  Created by Amaan on 2018-01-28.
//  Copyright © 2018 amaancan. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports": "⚽️🏀🏅⛷🏏🏓⛳️🏆🥋🏂🏑🏒🏉🎾⚾️",
        "Animals": "🐶🦊🦁🐸🐯🐣🐳🐠🦉🐹🐭🐱🙈🐧🐔",
        "Food": "🍎🥐🌶🍆🥑🍒🍑🍅🍇🍉🍌🍋🍏🍊🥕"
    ]
    
    override func awakeFromNib() { //  iOS calls it on every object in IB. Won't be called if made this obj via code.
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        // I'm adapting to the fact that I'm a splitVC on an iPhone. And I want to collapse the detailVC using a navigation controller on top of the masterVC. If we don't want it to collapse, return true. Don't do collapse when it's theme = nil.
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true // Don't do the collapse. I didn't select a theme yet!
            }
        }
        return false // Please do that collapse. Since I selected a theme.
    }
    
    private var concentrationDetailViewController: ConcentrationViewController? {
        // It'll return if it's able to find a concentrationDetailVC game inside the splitVC
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        
        if let cvc = concentrationDetailViewController {
            // If I'm in my splitVC and I can find my detailVC --> just talk to it to set the theme
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            // I'm not in a splitVC. So check if I've already segued in a nav controller before
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            // push w/o segue so it doesn't create new ConcentrationVC game obj, rather it pushes the old one
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            // @IB: Added generic segue from ThemeVC to ConcentraitonVC instead of directly from button since want to perform segue via code
            performSegue(withIdentifier: "ChangeTheme", sender: sender)
            
        }
        
    }
    
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTheme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                    // anytime segue successfully, hold a strong ref to it when it going 'back' usually throws out of heap, so we can push to SAME game obj and continue game where we left off
                }
            }
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
    }
    
    
}
