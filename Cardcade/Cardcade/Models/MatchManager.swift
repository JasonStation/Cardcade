//
//  MatchManager.swift
//  Cardcade
//
//  Created by Jason Leonardo on 19/05/23.
//

import Foundation
import GameKit

class MatchManager: NSObject, ObservableObject{
    @Published var authenticationState  = PlayerAuthState.authenticating
    @Published var isGameOver = false
    @Published var inGame = false
    
    @Published var isDrawing = true
    
    @Published var currentPlayer = 0
    
    @Published var cardAmount = 7
    @Published var cards = [startingDeck[0], startingDeck[1], startingDeck[2], startingDeck[3]]
    @Published var remainingTime = 30
    @Published var botCards = [startingDeck[1], startingDeck[2], startingDeck[3]]
    
    @Published var allowStacking = true
    
    @Published var lastDrawnCard = cardDeck.firstDrawnCard()
    @Published var lastDrawnColor = ""
    @Published var lastDrawnValue = "0"
    @Published var isStacking = false
    @Published var stackedCards = 0
    //MAX PLAYER = 4!!!
    @Published var numberOfPlayers = 4
    @Published var playerNames = ["Player", "Amy", "Bobby", "Cody"]
    
    @Published var oppositeTurn = false
    @Published var addedCards = 0
    @Published var winnerArray: [String] = []
    @Published var winnerPos = ["", "", "", ""]
    
    var match: GKMatch?
    var otherPlayers: [GKPlayer] = []
    var localPlayer = GKLocalPlayer.local
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController?{
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    
    func authenticateUser(){
        GKLocalPlayer.local.authenticateHandler = { [self] vc, e in
            if let viewController = vc {
                rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = e{
                authenticationState = .error
                print(error.localizedDescription)
                return
            }
            
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authenticationState = .restricted
                }else{
                    authenticationState = .authenticated
                }
            }else{
                authenticationState = .unauthenticating
            }
            
            
        }
    }
    
    func startMatchmaking(){
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 4
        
        let matchmakingVC = GKMatchmakerViewController(matchRequest: request)
        matchmakingVC?.matchmakerDelegate = self
        
        rootViewController?.present(matchmakingVC!, animated: true)
    }
    
    func startMatch(newMatch: GKMatch){
        match = newMatch
        match?.delegate = self
        
        cards[0] = startingDeck[0]
        inGame = true
        
        sendString("Draws first:\(playerUUIDKey)")
    }
    
    func receivedString(_ message: String){
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else {return}
                
        let parameter = String(messageSplit.last ?? "")
                
        switch messagePrefix{
        case "Draws first":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("Draws first:\(playerUUIDKey)")
                break
            }
            inGame = true
            
        default:
            break
            
        }
        
        
    }
    
}
