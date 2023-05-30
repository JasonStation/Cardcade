//
//  MainMenuView.swift
//  Cardcade
//
//  Created by Jason Leonardo on 19/05/23.
//

import SwiftUI
import SpriteKit

struct MainMenuView: View {
    @ObservedObject var matchManager: MatchManager
    @State var singlePlayer = false
    @State var localMultiplayer = false
    @State private var menuCard = cardDeck.drawCard()
    
    @State private var playMode = 0
    
    var body: some View {
        ZStack{
            if playMode == 0{
                VStack{
                    Text("Cardcade")
                        .font(.largeTitle)
                        .bold()
                    
                    ZStack{
                        Rectangle()
                            .fill(getColor(color: menuCard?.color ?? "Black"))
                            .frame(width: 90, height: 135)
                            .cornerRadius(10)
                            .padding(6)
                            .shadow(color: .gray, radius: 6, x: 0, y: 4)
                        if menuCard?.value == "Skip" || menuCard?.value == "Reverse" || menuCard?.value  == "+2" || menuCard?.value  == "+4" || menuCard?.value  == "Wild"{
                            getCardIcon(value: menuCard?.value ?? "Skip")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }else{
                            Text(menuCard?.value ?? "0")
                                .font(.title).bold()
                                .foregroundColor(.white)
                                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                        }
                        
                        
                        
                    }.padding(70)
                    
                    Button(action: {
                        //Start matchmaking
                        playMode = 1
                        matchManager.inGame = true
                    }) {
                            Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .padding(-1)
                            Text("Singleplayer")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                
                        
                    }
                    .frame(width: 250, height: 60)
                    .background(.blue)
                    .cornerRadius(30)
                    .padding(.top)
                    
                    Button(action: {
                        //Start matchmaking
                        playMode = 2
                        matchManager.inGame = true
                    }) {
                        Image(systemName: "person.3.fill")
                        .foregroundColor(.white)
                        .padding(-1)
                        Text("Local Multiplayer")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }.frame(width: 250, height: 60)
                        .background(.blue)
                        .cornerRadius(30)
                        .padding()
                    
                    Button(action: {
                        //playMode = 1
                        matchManager.startMatchmaking()
                    }) {
                        Image(systemName: "globe.europe.africa.fill")
                        .foregroundColor(.white)
                        .padding(-1)
                        Text("Online")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
            
                    }.frame(width: 250, height: 60)
                    .background(matchManager.authenticationState != .authenticated || matchManager.inGame ? .gray : .blue)
                        .opacity(matchManager.authenticationState != .authenticated || matchManager.inGame ? 0.5 : 1)
                        .cornerRadius(30)
                    .disabled(matchManager.authenticationState != .authenticated || matchManager.inGame)
                    
                    
                    Text(matchManager.authenticationState.rawValue)
                        .foregroundColor(.gray)
                    
                    
                }
            }else if playMode == 1 || playMode == 2{
                GameSettingsView(matchManager: matchManager, playMode: $playMode)
            }
        }.onAppear{
            matchManager.authenticateUser()
        }
    }
    
    func getColor(color: String) -> Color {
        switch color {
        case "Blue":
            return Color.blue
        case "Red":
            return Color.red
        case "Green":
            return Color.green
        case "Yellow":
            return Color.yellow
        default:
            return Color.black
        }
    }
    
    func getCardIcon(value: String) -> Image{
        
        switch value{
        case "Skip":
            return Image("skip_icon")
        case "Reverse":
            return Image("reverse_icon")
        case "+2":
            return Image("draw_two_icon")
        case "+4":
            return Image("draw_four_icon")
        case "Wild":
            return Image("wild_icon")
        default:
            return Image("")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(matchManager: MatchManager())
    }
}
