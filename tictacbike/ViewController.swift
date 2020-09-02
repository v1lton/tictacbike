//
//  ViewController.swift
//  tictacbike
//
//  Created by Wilton Ramos on 02/09/20.
//  Copyright © 2020 Wilton Ramos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let boardImageView = UIImageView()
    let buttons = [UIButton]()
    var activePlayer = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setupBoardImageView()
    }
    
    func setupBoardImageView() {
        self.view.addSubview(boardImageView)
        self.boardImageView.frame = CGRect(x: 289, y: 59, width: 616, height: 666)
        let boardImage = UIImage(named: "board.png")
        self.boardImageView.image = boardImage
    }
    
    @IBAction func pressSpace(_ sender: UIButton) {
        if (gameState[sender.tag] == 0) {
            gameState[sender.tag] = activePlayer
            if (activePlayer == 1) {
                sender.setImage(UIImage(named: "bike369.jpg"), for: .normal)
                activePlayer = 2
            } else {
                sender.setImage(UIImage(named: "bike194.jpg"), for: .normal)
                activePlayer = 1
            }
        }
    }
    
}

