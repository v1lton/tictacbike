//
//  SentimentAnalysisViewController.swift
//  tictacbike
//
//  Created by Juliano Vaz on 03/09/20.
//  Copyright © 2020 Wilton Ramos. All rights reserved.
//

import Foundation
import UIKit
import NaturalLanguage

class SentimentAnalysisViewController: UIViewController {

    
    @IBOutlet weak var sentimentLabelByModel: UILabel!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var mesageTextView: UITextView!
    
        
    @IBAction func sendMessage(_ sender: Any) {
    
    guard let message = self.mesageTextView?.text else {
                      return
        
            }
                print("dentro do send ms")
                print(message)
            detectSentimentWithModel(message: message)
            detectSentiment(message: message)

        }

        


    //testa com nosso modelo
    private func detectSentimentWithModel(message: String) {
        print("entrou na nossa")
            do {
                let sentimentDetector = try NLModel(mlModel: AnRandomSentimentClassifier().model)
                guard let prediction = sentimentDetector.predictedLabel(for: message) else {
                    print("Failed to predict result")
                    return
                }
                
                sentimentLabelByModel.text = "Our status: \(prediction)"
            } catch {
                fatalError("Failed to load Natural Language Model: \(error)")
            }
        }


       // range -1.0 (negative) to 1.0 (positive)
    // teste cmo modelo da apple
        private func detectSentiment(message: String) {
            print("entrou na da apple")
            let tagger = NLTagger(tagSchemes: [.sentimentScore])
            tagger.string = message
            
            let (sentiment, _) = tagger.tag(at: message.startIndex, unit: .paragraph, scheme: .sentimentScore)
            
            // it supports 7 languages: English, French, Italian, German, Spanish, Portuguese, and simplified Chinese.
            guard let sentimentScore = sentiment?.rawValue else {
                return
            }
            
            sentimentLabel.text = "sentiment score: \(sentimentScore)"
        }
    }


