//
//  ContentView.swift
//  Cardcade
//
//  Created by Jason Leonardo on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var matchManager = MatchManager()

    var body: some View {
//        ZStack{
//            if matchManager.isGameOver{
//
//            }else if matchManager.inGame{
//                GameView(matchManager: matchManager)
//            }else{
//                MainMenuView(matchManager: matchManager)
//            }
//        }.onAppear{
//            matchManager.authenticateUser()
//        }
        
        MainMenuView(matchManager: MatchManager())

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(matchManager: MatchManager())
    }
}
