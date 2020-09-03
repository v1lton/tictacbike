//
//  ViewController.swift
//  tictacbike
//
//  Created by Wilton Ramos on 02/09/20.
//  Copyright © 2020 Wilton Ramos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activePlayer = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var gameIsActive = true
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playAgainbutton: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    
    
    //8 possible combinations to win
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,7],[0,4,8],[2,4,6]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.isHidden = true
        playAgainbutton.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func pressSpace(_ sender: UIButton) {
        if (gameState[sender.tag] == 0 && gameIsActive == true) {
            gameState[sender.tag] = activePlayer
            if (activePlayer == 1) {
                sender.setImage(UIImage(named: "bike369.jpg"), for: .normal)
                activePlayer = 2
            } else {
                sender.setImage(UIImage(named: "bike194.jpg"), for: .normal)
                activePlayer = 1
            }
        }
        
        for combination in winningCombinations{
            // check possible winning combinations against current game state
            if (gameState[combination[0]] == 1
                && gameState[combination[0]] == gameState[combination[1]]
                && gameState[combination[1]] == gameState[combination[2]]
                ){
                
                print("entrou 1")
                
                //se todos os campos foram preenchidos
                gameIsActive = false
                
                if gameState[combination[0]] == 1{
                    //cross has won
                    print("CROSS")
                    label.text = "Chis has won!"
                    playAgainbutton.isHidden = false
                    label.isHidden = false
                      print("entrou 2")
                }
                else{
                    print("NOUGHT")
                    //nought has won
                    label.text = "Bola has won!"
                    playAgainbutton.isHidden = false
                    label.isHidden = false
                      print("entrou 3")
                    
                }
                  print("entrou 4")
                
                
            }
            
              print("entrou 5")
        }
        gameIsActive = false
        
        for i in gameState{
            if i == 0
            {
                gameIsActive = true
                break
            }
        }
        
        if gameIsActive == false {
            label.text = "Its was a draw"
            label.isHidden = false
            playAgainbutton.isHidden = false
        }
        
    }
    
    
    @IBAction func playAgain(_ sender: Any) {
        
        playAgainbutton.isHidden = true
        label.isHidden = true
        activePlayer = 1
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        gameIsActive = true
        
        
        b1.setImage(nil, for: .normal)
        b2.setImage(nil, for: .normal)
        b3.setImage(nil, for: .normal)
        b4.setImage(nil, for: .normal)
        b5.setImage(nil, for: .normal)
        b6.setImage(nil, for: .normal)
        b7.setImage(nil, for: .normal)
        b8.setImage(nil, for: .normal)
        b9.setImage(nil, for: .normal)
    }
    
    
    //        func fetchAnyPossibleIndexForMove() -> Int {
    //            var emptySquares : [Int] = [Int]()
    //            for i in 1...gameState.count {
    //                if gameState[i-1] == 0 {
    //                    emptySquares.append(i)
    //                }
    //            }
    //            if emptySquares.isEmpty {
    //                //print("Game has reached Error state ...!!")
    //                return -1
    //            }
    //            //print("found empty squares...")
    //            //print(emptySquares)
    //            // return any random empty space
    //            let randomSquare = arc4random_uniform(UInt32(emptySquares.count - 1))
    //            return emptySquares[Int(randomSquare)]
    //        }
}

