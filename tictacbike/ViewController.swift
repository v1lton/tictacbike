//
//  ViewController.swift
//  tictacbike
//
//  Created by Wilton Ramos on 02/09/20.
//  Copyright © 2020 Wilton Ramos. All rights reserved.
//

import UIKit
import Vision
import VideoToolbox

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
    
    //game variables
    var activePlayer = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        print(imagesAndDescriptions[0].1)
        print(imagesAndDescriptions[1].1)
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
        if (gameState[sender.tag] == 0) {
            gameState[sender.tag] = activePlayer
            if (activePlayer == 1) {
                sender.setImage(playerOneImage, for: .normal)
                activePlayer = 2
            } else {
                sender.setImage(playerTwoImage, for: .normal)
                activePlayer = 1
            }
        }
    }
    
}

