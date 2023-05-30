//
//  GameSettingsView.swift
//  Cardcade
//
//  Created by Jason Leonardo on 24/05/23.
//

import SwiftUI


struct GameSettingsView: View {
    @ObservedObject var matchManager: MatchManager
    //@State private var numberOfPlayers = 2
    @State private var playerNames: [String] = Array(repeating: "", count: 2)
    
    @State private var singlePlayer = false
    @State private var visibleWarning = false
    @State private var menuIndex = 0
    @Binding var playMode: Int
    
    var body: some View {
        if menuIndex == 0{
            
                VStack {
                    HStack{
                        Text("Game Settings")
                            .font(.largeTitle)
                            .bold()
                            .padding(.vertical, 30)
                            .padding(.horizontal, 30)
                        
                        Button(action: {
                            menuIndex = -1
                        }) {
                           Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                
                        }.padding(20)
                        
                    }
                    ScrollView(){
                    VStack{
                        
                        Toggle(isOn: $matchManager.allowStacking) {
                            Text("Allow card stacking")
                                .font(.headline)
                        }
                        .font(.title2)
                        .padding(.horizontal, 100)
                        .padding(.bottom, 50)
                        
                        
                        Text("Starting card amount:")
                            .font(.title2)
                        
                       
                        HStack{
                            
                            Button(action: {
                                subtractCard()
                            }) {
                                Text("-")
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                            }.padding()
                            
                            Text("\(matchManager.cardAmount)")
                                .font(.largeTitle)
                                .bold()
                            
                            Button(action: {
                                addCard()
                            }) {
                                Text("+")
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                            }.padding()
                            
                        }.padding(.bottom, 20)
                        
                        
                        
                        Text("Number of players:")
                            .font(.title2)
                        
                        HStack{
                            
                            Button(action: {
                                subtractPlayer()
                            }) {
                                Text("-")
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                            }.padding()
                            
                            Text("\(matchManager.numberOfPlayers)")
                                .font(.largeTitle)
                                .bold()
                            
                            Button(action: {
                                addPlayer()
                            }) {
                                Text("+")
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                            }.padding()
                            
                        }.padding(.bottom, 20)
                        
                        ForEach(0..<Int(matchManager.numberOfPlayers), id: \.self) { index in
                            Text("Player \(index + 1) Name").bold()
                            TextField("Player \(index + 1) Name", text: $matchManager.playerNames[index])
                                .font(.title2)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 300)
                                .padding()
                        }
                        
                        if visibleWarning{
                            Text("Player name cannot exceed 8 characters.")
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            if !checkForMaxCharacters(){
                                startGame()
                            }else{
                                visibleWarning = true
                            }
                        }) {
                            Text("Start Game")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 200 )
                                .bold()
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(30)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }else if menuIndex == 1{
            GameView(matchManager: matchManager)
        } else if menuIndex == 2{
            MultiplayerGameView(matchManager: matchManager)
        }
        else if menuIndex == -1{
            MainMenuView(matchManager: matchManager)
        }
    }
    
    func subtractCard(){
        if matchManager.cardAmount > 2{
            matchManager.cardAmount -= 1
        }
    }
    
    func addCard(){
        if matchManager.cardAmount < 30{
            matchManager.cardAmount += 1
        }
    }
    
    func subtractPlayer(){
        if matchManager.numberOfPlayers > 2{
            matchManager.numberOfPlayers -= 1
        }
    }
    
    func addPlayer(){
        if matchManager.numberOfPlayers < 4{
            matchManager.numberOfPlayers += 1
        }
    }
    
    func checkForMaxCharacters() -> Bool{
        for i in 0..<4{
            if matchManager.playerNames[i].count >= 8{
                return true
            }
        }
        return false
    }
    
    func startGame(){
        if playMode == 1{
            menuIndex = 1
        }else if playMode == 2{
            menuIndex = 2
        }
    }
    
    struct GameSettingsView_Preview: PreviewProvider {
        static var previews: some View {
            GameSettingsView(matchManager: MatchManager(), playMode: .constant(0))
        }
    }
}
