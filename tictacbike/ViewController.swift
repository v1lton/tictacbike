//
//  ViewController.swift
//  tictacbike
//
//  Created by Wilton Ramos on 02/09/20.
//  Copyright © 2020 Wilton Ramos. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import NaturalLanguage

class ViewController: UIViewController {
    
    //model variables
    let model = MobileNetV2()
    let incidents = Bikes(incidents: [])
    var URLsAndDescriptions = [URLAndDescription]()
    var imagesAndDescriptions = [imageAndDescription]()
    var playerOneImage = UIImage()
    var playerTwoImage = UIImage()
    typealias Prediction = (String, Double)
    typealias URLAndDescription = (URL, String)
    typealias imageAndDescription = (UIImage, String)
    @IBOutlet weak var fundoArvore: UIImageView!
    
    //game variables
    var activePlayer = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var gameIsActive = true
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var sentimentAnalysisButton: UIButton!
    @IBOutlet weak var bikeDetectionButton: UIButton!
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
        sentimentAnalysisButton.isHidden = true
        bikeDetectionButton.isHidden = true
        fundoArvore.isHidden = true
        
        
        // Do any additional setup after loading the view.
        createSpinnerView()
        collectURLs()
      
    }
    
    func predictUsingVision(image: UIImage) -> Bool {
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Someone did a baddie")
        }
        var isBike = false
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let observations = request.results as? [VNClassificationObservation] {
                let top5 = observations.prefix(through: 2) //change to top2
                    .map { ($0.identifier, Double($0.confidence)) }
                let isItBike = self.isItBike(results: top5)
                if isItBike {
                    isBike = true
                }
            }
        }
        request.imageCropAndScaleOption = .centerCrop
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request])
        //Não sei que danado é isso
        return isBike
    }
    
    func isItBike(results: [Prediction]) -> Bool {
        let bikeString = "mountain bike, all-terrain bike, off-roader"
        if results[0].0 == bikeString || results[1].0 == bikeString {
            return true
        }
        return false
    }
    
    func getTwoBikeImages() {
        var aux = 0
        while imagesAndDescriptions.count < 2 {
            getImage(url: URLsAndDescriptions[aux])
            aux += 1
        }
        playerOneImage = imagesAndDescriptions[0].0
        playerTwoImage = imagesAndDescriptions[1].0
        print("To aqui")
    }
    
    func getImage(url: URLAndDescription) {
        var bikeImage = UIImage()
        if let data = try? Data(contentsOf: url.0) {
            bikeImage = UIImage(data: data)!
        }
        let isItBike = predictUsingVision(image: bikeImage)
        if isItBike {
            imagesAndDescriptions.append((bikeImage, url.1))
        }
    }
    
    func collectURLs() {
        let incidentsNumber = 20 //no specific reason for choosing 20
        let stringURL = "https://bikewise.org/api/v2/incidents?page=1&per_page=\(incidentsNumber)"
        let url = URL(string:stringURL)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Bikes.self, from: data!)
                DispatchQueue.main.async {
                    self.getURLsAndIncidents(incidents: jsonData)
                    self.getTwoBikeImages()
                    self.fundoArvore.isHidden = false
                }
            } catch {
                print ("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
       
    }
    
    func getURLsAndIncidents(incidents: Bikes) {
        for incident in incidents.incidents {
            let imageString = incident.media.imageURL
            if imageString != nil {
                let imageURL = URL(string: imageString!)
                let incidentDescription = incident.incidentDescription
                if incidentDescription != nil {
                    self.URLsAndDescriptions.append((imageURL!, incidentDescription!))
                }
            }
        }
    }
    
    @IBAction func pressSpace(_ sender: UIButton) {
        if (gameState[sender.tag] == 0 && gameIsActive == true) {
            gameState[sender.tag] = activePlayer
            if (activePlayer == 1) {
                sender.setImage(playerOneImage, for: .normal)
                activePlayer = 2
            } else {
                sender.setImage(playerTwoImage, for: .normal)
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
                    label.text = "Jogador 1 ganhou!!"
                    detectSentimentWithModel(imagesAndDescriptions[0].1)
                    playAgainbutton.isHidden = false
                    label.isHidden = false
                    sentimentAnalysisButton.isHidden = false
                    bikeDetectionButton.isHidden = false
                    print("entrou 2")
                }
                else{
                    print("NOUGHT")
                    //nought has won
                    label.text = "Jogador 1 ganhou!"
                    detectSentimentWithModel(imagesAndDescriptions[1].1)
                    playAgainbutton.isHidden = false
                    label.isHidden = false
                    sentimentAnalysisButton.isHidden = false
                    bikeDetectionButton.isHidden = false
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
        sentimentAnalysisButton.isHidden = true
        bikeDetectionButton.isHidden = true
        
        
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
    
    private func detectSentimentWithModel(_ message: String) {
        do {
            let sentimentDetector = try NLModel(mlModel: AnRandomSentimentClassifier().model)
            guard let prediction = sentimentDetector.predictedLabel(for: message) else {
                print("Failed to predict result")
                return
            }
            if prediction == "negative" {playNegativeSound()}
            else {playPositiveSound()}
        } catch {
            fatalError("Failed to load Natural Language Model: \(error)")
        }
    }
    
    private func playNegativeSound() {
        let pathToSound = Bundle.main.path(forResource: "Thunderstorm", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
    }
    
    private func playPositiveSound() {
        let pathToSound = Bundle.main.path(forResource: "Birds", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
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
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}

