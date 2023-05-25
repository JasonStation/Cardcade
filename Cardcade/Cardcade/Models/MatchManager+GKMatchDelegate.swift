//
//  MatchManager+GKMatchDelegate.swift
//  Cardcade
//
//  Created by Jason Leonardo on 22/05/23.
//

import Foundation
import GameKit

extension MatchManager: GKMatchDelegate {
//    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
//        let content = String(decoding: data, as: UTF8.self)
//
//        if content.starts(with: "strData:"){
//
//        }else{
//            do{
//                //TODO: figure this out
//                try lastDrawnCard = lastDrawnCard
//            }catch{
//                print(error)
//            }
//        }
//    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
           do {
               let decoder = JSONDecoder()
               let card = try decoder.decode(UNOCard.self, from: data)
               // Process the received card data and handle it according to your game logic
               // Example:
               // print("Received card: color - \(card.color), value - \(card.value)")
               lastDrawnCard = card
           } catch {
               print("Failed to decode received card data: \(error)")
           }
       }
    
    func sendLastDrawnCard(card: UNOCard, to players: [GKPlayer], mode: GKMatch.SendDataMode) {
            guard let match = match else {
                print("No active match")
                return
            }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(card)
                try match.sendData(toAllPlayers: data, with: mode)
            } catch {
                print("Failed to send last drawn card data: \(error)")
            }
    }
    
    
    func sendString(_ message: String){
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode){
        do{
            try match?.sendData(toAllPlayers: data, with: mode)
        }catch{
           print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
            if state == .connected {
                otherPlayers.append(player)
            } else if state == .disconnected {
                if let index = otherPlayers.firstIndex(of: player) {
                    otherPlayers.remove(at: index)
                }
            }
    }
}
