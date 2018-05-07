//
//  ViewController.swift
//  ApplePie
//
//  Created by kevin on 2018/5/4.
//  Copyright © 2018年 KevinChang. All rights reserved.
//

import UIKit
import Foundation
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var corretWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var spendTimeLabel: UILabel!
    
    
    let incorrectMovesAllowed = 7
    var totalWins = 0
    var totalLosses = 0
    var currentGame: Game!
    
    let themeDistribution = GKRandomDistribution(lowestValue: 0, highestValue: theme.count - 1)
    var newGameTheme: String?
    var newGameList: [String?] = []
    var round = 0
    var totalScore = 0
    var currentScore = 0
    
    var gameTimer = Timer()
    var speedSconds = 0
    
    // MARK: 字母按鍵
    @IBAction func letterBtnPressed (_ sender: UIButton){
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    // MARK: 下一回合
    func newRound() {
        hintLabel.isHidden = true
        spendTimeLabel.isHidden = false
        newGameTheme = theme[themeDistribution.nextInt()]
        newGameList = listOfQuestionWords["\(newGameTheme ?? "animails")"]!
        let wordsDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: newGameList.count - 1)
        currentScore = 0
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countingSpeedTime), userInfo: nil, repeats: true)
        
        if round < 5 {
            let newword = newGameList[wordsDistribution.nextInt()]!
            currentGame = Game(word: newword, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [], score: currentScore)
            round += 1
            enableLetterButtons(true)
            updateUI()
            
            hintButton.isHidden = false
            hintButton.isEnabled = true
        }else if round == 5{
            gameTimer.invalidate()
            performSegue(withIdentifier: "gameResultsSegue", sender: nil)
        }
        hintLabel.text = "\(newGameTheme ?? "animals")"
    }
    
    // MARK: 更新UI畫面
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        corretWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Loses: \(totalLosses)"
        totalScoreLabel.text = "Score: \(totalScore)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        UIView.transition(with: treeImageView, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        
        if currentGame.incorrectMovesRemaining == 0 {
            lose()
        }else if currentGame.word == currentGame.formattedWord {
            win()
        }
    }
    
    // MARK: 更新分數狀態
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
            totalScore -= 50
            totalScore += currentGame.score
            updateUI()
        }else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
            totalScore += 100
            totalScore += currentGame.score
            updateUI()
        }else {
            totalScore += currentGame.score
            updateUI()
        }
    }
    
    // MARK: 字母按鍵的啟動
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    // MARK: 提示按鍵
    @IBAction func hintButtonPressed(_ sender: Any){
        hintLabel.isHidden = false
        hintButton.isHidden = true
        
        totalScore -= 50
        totalScoreLabel.text = "Score: \(totalScore)"
    }
    
    // MARK: Alert
    func nextHandler (action: UIAlertAction) {
        newRound()
    }
    
    func win () {
        let controller = UIAlertController(title: "Correct!", message: "Good job!", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertActionStyle.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        gameTimer.invalidate()
    }
    
    func lose () {
        let controller = UIAlertController(title: "Out of moves!", message: "Answer: " + currentGame.word, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertActionStyle.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        gameTimer.invalidate()
    }
    
    // MARK: unwind
    @IBAction func unwindToMultipleChoicePage(segue: UIStoryboardSegue){
        round = 0
        totalWins = 0
        totalLosses = 0
        totalScore = 0
        speedSconds = 0
        spendTimeLabel.text = "00:00"
        newRound()
    }
    
    // MARK: Timer
    @objc func countingSpeedTime() {
        let showMinutes = String(format: "%02d", speedSconds / 60)
        let showSeconds = String(format: "%02d", speedSconds % 60)
        spendTimeLabel.text = "\(showMinutes):\(showSeconds)"
        speedSconds += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hintButton.isHidden = false
        hintButton.isEnabled = false

        newRound()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controllor = segue.destination as? GameResultsViewController
        controllor?.totalScore = totalScoreLabel.text
        controllor?.score = scoreLabel.text
        controllor?.spendTime = spendTimeLabel.text
    }

}

