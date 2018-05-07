//
//  GameStruct.swift
//  ApplePie
//
//  Created by kevin on 2018/5/6.
//  Copyright © 2018 KevinChang. All rights reserved.
//

import Foundation

struct Game {
    var word: String
    var incorrectMovesRemaining: Int
    var guessedLetters:[Character]
    var score = 0
    
    mutating func playerGuessed(letter: Character){
        guessedLetters.append(letter)
        score = 0
        if !word.contains(letter){
            incorrectMovesRemaining -= 1
            score -= 5
        }else {
            score += 10
        }
    }
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            }else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
}
