
//
//  CardDeck.swift
//  Cardcade
//
//  Created by Jason Leonardo on 17/05/23.
//

import Foundation
import SwiftUI

// UNO Card
struct UNOCard: Codable {
    var color: String
    var value: String
    
    init(color: String, value: String) {
        self.color = color
        self.value = value
    }
}

// UNO Deck
class UNODeck {
    var cards: [UNOCard]
    
    init() {
        self.cards = []
        generateDeck()
    }
    
    func generateDeck() {
        let colors = ["Red", "Green", "Blue", "Yellow"]
        let values = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Skip", "Reverse", "+2"]
        
        for color in colors {
            cards.append(UNOCard(color: color, value: "0"))
            
            
            for value in values {
                if value != "0" || value != "Wild" || value != "+4"{
                    cards.append(UNOCard(color: color, value: value))
                    //cards.append(UNOCard(color: color, value: value))
                }
            }
            cards.append(UNOCard(color: "Black", value: "Wild"))
            cards.append(UNOCard(color: "Black", value: "+4"))
        }
        
    
    }
    
    func drawCard() -> UNOCard? {
        if cards.isEmpty {
            return nil
        }
        
        let randomIndex = Int.random(in: 0..<cards.count)
        let card = cards[randomIndex]
       // cards.remove(at: randomIndex)
        
        return card
    }
    
    func firstDrawnCard() -> UNOCard? {
        let colorDraw = ["Red", "Green", "Blue", "Yellow"]
        let numberDraw = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        let randomColorIndex = Int.random(in: 0..<colorDraw.count)
        let randomNumberIndex = Int.random(in: 0..<numberDraw.count)
        
        return UNOCard(color: colorDraw[randomColorIndex], value: numberDraw[randomNumberIndex])
    }
}

let cardDeck = UNODeck()

var oneCard = [cardDeck.drawCard()]

var startingDeck: [[UNOCard?]] = [[], [], [], []]

var playerTestMany = [cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard(),
                  cardDeck.drawCard()]
