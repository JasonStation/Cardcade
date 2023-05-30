import SwiftUI
import SpriteKit
import AVFoundation

struct MultiplayerGameView: View {
    @ObservedObject var matchManager: MatchManager
    
    @State private var selectedCard = 0
    @State private var cardOffset: CGSize = .zero
    
    @State private var defaultPosition = [
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100)]
    
    @State private var cardPosition = [
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100)]
    
    @State private var finalPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 180)
    
    @State private var arrowPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 180)
    
    @State private var cardWidth = CGFloat(90)
    @State private var cardHeight = CGFloat(135)
    
    @State private var opponentCardWidth = CGFloat(90)
    @State private var opponentCardHeight = CGFloat(135)
    
    @State private var showColorChooser = false
    var colorChooser = ["Red", "Blue", "Green", "Yellow"]
    @State private var colorChooserIndex = 0
    @State private var addTurn = 1
    
    @State private var hideCards = false
    @State private var nextPlayerMenu = false
    
    @State private var winnerStatus = [false, false, false, false]
    
    @State private var positions = ["1st", "2nd", "3rd", "4th"]
    @State private var winnerIndex = 0
    @State private var winnerMenu = false

    @State private var gameOver = false
    
    @State private var playerIndex: [Int] = []
    
    @State private var menuOptions = false
    
    
    var body: some View {
        if !gameOver{
            ZStack{
                VStack (alignment: .center) {
                    Spacer()
                    HStack{
                        ZStack{
                            
                            //Player 2 Stack
                            
                            VStack(spacing: -300){
                                ForEach(matchManager.cards[(matchManager.currentPlayer + 1) % matchManager.numberOfPlayers].indices.prefix(30), id: \.self) { index in
                                    Rectangle()
                                        .fill(Color.cyan)
                                        .frame(width: opponentCardHeight, height: opponentCardWidth)
                                        .cornerRadius(10)
                                    
                                        .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                        .position(x: 0, y: UIScreen.main.bounds.width / 2.5)
                                }
                            }
                                HStack{
                                    Text("\(matchManager.playerNames[(matchManager.currentPlayer + 1) % matchManager.numberOfPlayers])")
                                    //  .font(.title)
                                    
                                    if matchManager.cards[(matchManager.currentPlayer + 1) % matchManager.numberOfPlayers].count > 0{
                                        Text("\(matchManager.cards[(matchManager.currentPlayer + 1) % matchManager.numberOfPlayers].count)")
                                            .font(.title)
                                            .bold()
                                    }else{
                                        Text("\(matchManager.winnerPos[(matchManager.currentPlayer + 1) % matchManager.numberOfPlayers])")
                                            .font(.title)
                                            .bold()
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(15)
                                .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                .position(x: UIScreen.main.bounds.width / 5, y: UIScreen.main.bounds.width / 1.07)
                            
                            
                            //Player 3 Stack
                            
                            if matchManager.numberOfPlayers >= 3{
                                HStack(spacing: -300){
                                    ForEach(matchManager.cards[(matchManager.currentPlayer + 2) % matchManager.numberOfPlayers].indices.prefix(30), id: \.self) { index in
                                        Rectangle()
                                            .fill(Color.cyan)
                                            .frame(width: opponentCardWidth, height: opponentCardHeight)
                                            .cornerRadius(10)
                                        
                                            .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                            .position(x: UIScreen.main.bounds.width / 2.5, y: 0)
                                    }
                                }
                                
                                HStack{
                                    Text("\(matchManager.playerNames[(matchManager.currentPlayer + 2) % matchManager.numberOfPlayers])")
                                    //  .font(.title)
                                    
                                    if matchManager.cards[(matchManager.currentPlayer + 2) % matchManager.numberOfPlayers].count > 0{
                                        Text("\(matchManager.cards[(matchManager.currentPlayer + 2) % matchManager.numberOfPlayers].count)")
                                            .font(.title)
                                            .bold()
                                    }else{
                                        Text("\(matchManager.winnerPos[(matchManager.currentPlayer + 2) % matchManager.numberOfPlayers])")
                                            .font(.title)
                                            .bold()
                                    }
                                    
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(15)
                                .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                .position(x: UIScreen.main.bounds.width / 2, y: 50)
                            }
                            
                            ZStack{
                                
                                if matchManager.oppositeTurn{
                                    Image("directionArrow")
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                        .position(arrowPosition)
                                        .opacity(0.15)
                                    
                                }else{
                                    Image("directionArrow")
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                        .position(arrowPosition)
                                        .opacity(0.15)
                                        .scaleEffect(x: -1, y: 1)
                                }
                                
                                
                                ZStack{
                                    Rectangle()
                                        .fill(getColor(color: matchManager.lastDrawnColor))
                                        .frame(width: cardWidth, height: cardHeight)
                                        .cornerRadius(10)
                                        .padding(6)
                                        .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                    if matchManager.lastDrawnValue == "Skip" || matchManager.lastDrawnValue == "Reverse" || matchManager.lastDrawnValue  == "+2" || matchManager.lastDrawnValue  == "+4" || matchManager.lastDrawnValue  == "Wild"{
                                        getCardIcon(value: matchManager.lastDrawnValue)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                    }else{
                                        Text(matchManager.lastDrawnValue)
                                            .font(.title).bold()
                                            .foregroundColor(.white)
                                            .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                                    }
                                    
                                    
                                    
                                }.position(finalPosition)
                                
                                if matchManager.addedCards > 0{
                                    Text("+\(matchManager.addedCards)")
                                        .font(.title)
                                        .bold()
                                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 20)
                                }
                                
                                ZStack{
                                    Rectangle()
                                        .fill(getColor(color: matchManager.lastDrawnCard?.color ?? "Black"))
                                        .frame(width: cardWidth, height: cardHeight)
                                        .cornerRadius(10)
                                        .padding(6)
                                    
                                    if matchManager.lastDrawnCard?.value == "Skip" || matchManager.lastDrawnCard?.value == "Reverse" || matchManager.lastDrawnCard?.value  == "+2" || matchManager.lastDrawnCard?.value  == "+4" || matchManager.lastDrawnCard?.value == "Wild"{
                                        getCardIcon(value: matchManager.lastDrawnCard?.value ?? "None")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                    }else{
                                        Text(matchManager.lastDrawnCard?.value ?? "None")
                                            .font(.title).bold()
                                            .foregroundColor(.white)
                                    }
                                    
                                    
                                }.position(cardPosition[matchManager.currentPlayer])
                            }
                            Spacer()
                            Spacer()
                            
                            //Player 4 Stack
                            
                            if matchManager.numberOfPlayers >= 4{
                                VStack(spacing: -300){
                                    ForEach(matchManager.cards[(matchManager.currentPlayer + 3) % matchManager.numberOfPlayers].indices.prefix(30), id: \.self) { index in
                                        Rectangle()
                                            .fill(Color.cyan)
                                            .frame(width: opponentCardHeight, height: opponentCardWidth)
                                            .cornerRadius(10)
                                        
                                            .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                            .position(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.width / 2.5)
                                    }
                                }
                                
                                HStack{
                                    Text("\(matchManager.playerNames[(matchManager.currentPlayer + 3) % matchManager.numberOfPlayers])")
                                    //  .font(.title)
                                    
                                    if matchManager.cards[(matchManager.currentPlayer + 3) % matchManager.numberOfPlayers].count > 0{
                                        Text("\(matchManager.cards[(matchManager.currentPlayer + 3) % matchManager.numberOfPlayers].count)")
                                            .font(.title)
                                            .bold()
                                    }else{
                                        Text("\(matchManager.winnerPos[(matchManager.currentPlayer + 3) % matchManager.numberOfPlayers])")
                                            .font(.title)
                                            .bold()
                                    }
                                    
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(15)
                                .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                .position(x: UIScreen.main.bounds.width / 1.25, y: UIScreen.main.bounds.width / 1.07)
                            }
                            
                            if !winnerMenu{
                                Button(action: {
                                    if !menuOptions{
                                        menuOptions = true
                                    }else{
                                        menuOptions = false
                                    }
                                    
                                }) {
                                    Image(systemName: "list.bullet.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    
                                    
                                }
                                .position(x: UIScreen.main.bounds.width / 6.2, y: 10)
                                
                                if !nextPlayerMenu && !menuOptions{
                                    Button(action: {
                                        hideCardBtn()
                                        
                                    }) {
                                        Image(systemName: hideCards ? "eye.circle" : "eye.slash.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        
                                        
                                    }
                                    .position(x: UIScreen.main.bounds.width / 1.17, y: 10)
                                }
                                
                            }
                            
                            
                        }
                    }
                    
                    
                    Spacer()
                    if matchManager.cards[matchManager.currentPlayer].count > 0{

                        HStack{
                            Text("\(matchManager.playerNames[matchManager.currentPlayer])'s cards (\(matchManager.cards[matchManager.currentPlayer].count))")
                                .font(.title2).bold().padding(.horizontal)
                            
                            Spacer()
                            
                            if matchManager.isDrawing && matchManager.isStacking{
                                Button(action: {
                                    endTurn()
                                    
                                }) {
                                    Text("End turn")
                                        .font(.system(size: 22, weight: .bold)) .frame(width: 120, height: 50)
                                        .foregroundColor(.white)
                                        .background(.red)
                                        .cornerRadius(30)
                                }.padding(.horizontal)
                            }
                            
                            
                        }
                        
                        
                        
                        //Player cards
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(matchManager.cards[matchManager.currentPlayer].indices, id: \.self) { index in
                                    ZStack{
                                        if !hideCards{
                                            Rectangle()
                                                .fill(getColor(color: matchManager.cards[matchManager.currentPlayer][index]?.color ?? "Black"))
                                                .frame(width: cardWidth, height: cardHeight)
                                                .cornerRadius(10)
                                                .padding(6)
                                                .offset(getOffset(index: index))
                                                .shadow(color: selectedCard == index && matchManager.isDrawing ? .gray : .clear, radius: 6, x: 0, y: 4)
                                                .blur(radius: selectedCard == index && matchManager.isDrawing ? 4 : 0)
                                                .opacity(matchManager.isDrawing ? 1 : 0.4)
                                            
                                            
                                            if matchManager.cards[matchManager.currentPlayer][index]?.value == "Skip" || matchManager.cards[matchManager.currentPlayer][index]?.value == "Reverse" || matchManager.cards[matchManager.currentPlayer][index]?.value == "+2" || matchManager.cards[matchManager.currentPlayer][index]?.value == "+4" || matchManager.cards[matchManager.currentPlayer][index]?.value == "Wild"{
                                                getCardIcon(value: matchManager.cards[matchManager.currentPlayer][index]?.value ?? "")
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                
                                            }else{
                                                Text(matchManager.cards[matchManager.currentPlayer][index]?.value ?? "None")
                                                    .font(.title).bold()
                                                    .foregroundColor(.white)
                                                    .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                                                
                                                
                                            }
                                        }else{
                                            Rectangle()
                                                .fill(.cyan)
                                                .frame(width: cardWidth, height: cardHeight)
                                                .cornerRadius(10)
                                                .padding(6)
                                                .offset(getOffset(index: index))
                                                .shadow(color: selectedCard == index && matchManager.isDrawing ? .gray : .clear, radius: 6, x: 0, y: 4)
                                                .blur(radius: selectedCard == index && matchManager.isDrawing ? 4 : 0)
                                                .opacity(matchManager.isDrawing ? 1 : 0.4)
                                        }
                                        
                                        
                                    }.disabled(!matchManager.isDrawing)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.5))
                                        .onTapGesture {
                                            withAnimation {
                                                selectedCard = index
                                            }
                                            print(selectedCard)
                                        }
                                        .offset(y: selectedCard == index ? -20 : 0)
                                }//
                            }
                            .padding(.top)
                            .padding(.horizontal)
                        }
                        HStack{
                            Spacer()
                    
                            if !matchManager.isStacking && (matchManager.cards[matchManager.currentPlayer][selectedCard]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[matchManager.currentPlayer][selectedCard]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[matchManager.currentPlayer][selectedCard]?.color == "Black")) && matchManager.isDrawing && !nextPlayerMenu {
                                Button(action: {
                                    replaceCard(cardIndex: selectedCard)
                                    
                                }) {
                                    Text("Play card")
                                        .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .cornerRadius(30)
                                }
                            }else if matchManager.isStacking && (matchManager.cards[matchManager.currentPlayer][selectedCard]?.value == matchManager.lastDrawnCard?.value)  && matchManager.isDrawing && matchManager.allowStacking && !nextPlayerMenu{
                                Button(action: {
                                    replaceCard(cardIndex: selectedCard)
                                    
                                }) {
                                    Text("Play card")
                                        .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .cornerRadius(30)
                                }
                            }else if !matchManager.isStacking
                                        && checkCompatibleCards() == false && !nextPlayerMenu
                            {
                                Button(action: {
                                    matchManager.cards[matchManager.currentPlayer].insert(cardDeck.drawCard(), at: 0)
                                    endTurn()
                                    
                                }) {
                                    Text("Take Card from Deck")
                                        .font(.system(size: 25, weight: .bold)) .frame(width: 300, height: 60)
                                        .foregroundColor(.white)
                                        .background(.orange)
                                        .cornerRadius(30)
                                }
                            }
                            else{
                                Text("")
                                    .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                                    .opacity(0)
                            }
                            // }
                            Spacer()
                            
                        }
                    }else{
                        Text("\(matchManager.winnerPos[0])")
                            .font(.title)
                            .bold()
                            .foregroundColor(.gray)
                        Text("You ran out of cards")
                            .bold()
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }.onAppear{
                    
                    matchManager.lastDrawnColor = matchManager.lastDrawnCard?.color ?? "Black"
                    matchManager.lastDrawnValue = matchManager.lastDrawnCard?.value ?? "0"
                    
                    for _ in 0..<matchManager.cardAmount{
                        matchManager.cards[0].append(cardDeck.drawCard())
                        matchManager.cards[1].append(cardDeck.drawCard())
                        if matchManager.numberOfPlayers >= 3{
                            matchManager.cards[2].append(cardDeck.drawCard())
                        }
                        if matchManager.numberOfPlayers >= 4{
                            matchManager.cards[3].append(cardDeck.drawCard())
                        }
                    }
                }
                
                if showColorChooser{
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .frame(height: 500)
                            .shadow(color: .gray, radius: 100, x: 10, y: 10)
                            .padding()
                        
                        VStack{
                            Text("Select Card Color")
                                .font(.title)
                                .bold()
                                .padding()
                            HStack {
                                ForEach(colorChooser.indices, id: \.self) { index in
                                    ZStack{
                                        Rectangle()
                                            .fill(getColor(color: colorChooser[index]))
                                            .frame(width: 70, height: 105)
                                            .cornerRadius(10)
                                            .padding(6)
                                            .offset(getOffset(index: index))
                                            .shadow(color: colorChooserIndex == index  ? .gray : .clear, radius: 6, x: 0, y: 4)
                                            .blur(radius: colorChooserIndex == index ? 4 : 0)
                                        
                                        
                                    }.disabled(!matchManager.isDrawing)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.5))
                                        .onTapGesture {
                                            withAnimation {
                                                colorChooserIndex = index
                                            }
                                            
                                        }
                                        .offset(y: colorChooserIndex == index ? -20 : 0)
                                }
                            }
                            
                            Text("\(colorChooser[colorChooserIndex])")
                                .font(.title2)
                                .padding(.bottom, 30)
                                .padding()
                            
                            Button(action: {
                                selectedCard = 0
                                chosenColor(index: colorChooserIndex)
                                showColorChooser = false
                                nextPlayerMenu = true
                                hideCards = true
                                nextTurn()
                            }) {
                                Text("Select color")
                                    .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                            }.padding()
                            
                        }
                    }
                }
                
                if nextPlayerMenu{
                    Rectangle()
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .frame(height: 500)
                        .shadow(color: .gray, radius: 100, x: 10, y: 10)
                        .padding()
                    
                    VStack{
                        Text("You ended your turn!")
                            .font(.title)
                            .bold()
                            .padding(30)
                        HStack{
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width: 60, height: 50)
                            
                            Image(systemName: "iphone.gen3")
                                .resizable()
                                .frame(width: 60, height: 100)
                        }
                        
                        Text("Pass this device to:")
                            .font(.title2)
                            .padding(.top, 30)
                        
                        Text("\(matchManager.playerNames[matchManager.currentPlayer])")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 50)
                        
                        Button(action: {
                            nextPlayerMenu = false
                            hideCards = false
                            
                        }) {
                            Text("Done")
                                .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(30)
                        }
                    }
                }
                
                if menuOptions{
                    Rectangle()
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .frame(height: 500)
                        .shadow(color: .gray, radius: 100, x: 10, y: 10)
                        .padding()
                    
                    VStack{
                        Text("Menu")
                            .font(.title)
                            .bold()
                            .padding(30)
                        
                        Button(action: {
                            menuOptions = false
                            
                        }) {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 50, height: 60)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 120)
                                .background(.blue)
                                .cornerRadius(100)
                                .shadow(color: .gray, radius: 5, x: 0, y: 6)
                        }
                                
                        
                        
                        Text("Continue")
                            .font(.title2)
                            .padding()
                            .padding(.bottom, 30)
                        
                        Button(action: {
                            gameOver = true
                            
                        }) {
                            Text("Quit Game")
                                .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                .foregroundColor(.white)
                                .background(.red)
                                .cornerRadius(30)
                        }
                    }
                }
            
                if winnerMenu{
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 100, x: 10, y: 10)
                            .padding()
                        
                        VStack{
                            Text("Match Results")
                                .font(.title)
                                .bold()
                                .padding(30)
                            
                            
                            ForEach(matchManager.winnerArray.indices, id: \.self) { index in
                                ZStack{
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width / 1.3, height: 80)
                                        .foregroundColor(.cyan)
                                        .cornerRadius(20)
                                    
                                    HStack{
                                        Text("\(positions[index])")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                        
                                        Text("\(matchManager.winnerArray[index])")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                            }
                            
                            Button(action: {
                                
                                gameOver = true
                            }) {
                                Text("Continue")
                                    .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(30)
                            }.padding(30)
                            
                        }
                    }
                }
                
            }.background(.white)
        }else{
            MainMenuView(matchManager: MatchManager())
        }
        
    }
    
    func chosenColor(index: Int){
        switch index{
        case 0:
            matchManager.lastDrawnCard?.color = "Red"
            matchManager.lastDrawnColor = "Red"
            break
        case 1:
            matchManager.lastDrawnCard?.color = "Blue"
            matchManager.lastDrawnColor = "Blue"
            break
        case 2:
            matchManager.lastDrawnCard?.color = "Green"
            matchManager.lastDrawnColor = "Green"
            break
        case 3:
            matchManager.lastDrawnCard?.color = "Yellow"
            matchManager.lastDrawnColor = "Yellow"
            break
        default:
            break
        }
    }
    
    func checkWinners(){
        var winners = 0
        for i in 0..<matchManager.numberOfPlayers{
            if matchManager.cards[i].count <= 0 && winnerStatus[i] == false{
                winnerStatus[i] = true
                matchManager.winnerArray.append(matchManager.playerNames[i])
                matchManager.winnerPos[i] = positions[winnerIndex]
                winnerIndex += 1
            }
            
            if matchManager.cards[i].count <= 0{
                winners += 1
            }
        }
        
        if winners >= matchManager.numberOfPlayers - 1{
            for i in 0..<matchManager.numberOfPlayers{
                if matchManager.cards[i].count > 0{
                    winnerStatus[i] = true
                    matchManager.cards[i].removeAll()
                    matchManager.winnerArray.append(matchManager.playerNames[i])
                    matchManager.winnerPos[i] = positions[winnerIndex]
                    winners += 1
                }
            }
            winnerMenu = true
        }
    }
    
    func nextTurn(){
        checkWinners()
        
        var opposite = 1
        if matchManager.oppositeTurn{
            opposite = (addTurn * -1)
        }
        
        matchManager.isStacking = false
        
        for _ in 0..<addTurn{
            matchManager.currentPlayer += (1 * opposite)
            matchManager.currentPlayer %= matchManager.numberOfPlayers
            for _ in 0..<matchManager.numberOfPlayers{
                if matchManager.currentPlayer < 0{
                    matchManager.currentPlayer = (matchManager.numberOfPlayers - 1)
                }
                if matchManager.currentPlayer == 0 && matchManager.cards[0].count <= 0{
                    matchManager.currentPlayer += (1 * opposite)
                }
                else if matchManager.currentPlayer == 1 && matchManager.cards[1].count <= 0{
                    matchManager.currentPlayer += (1 * opposite)
                }
                else if matchManager.currentPlayer == 2 && matchManager.cards[2].count <= 0{
                    matchManager.currentPlayer += (1 * opposite)
                }
                else if matchManager.currentPlayer == 3 && matchManager.cards[3].count <= 0{
                    matchManager.currentPlayer += (1 * opposite)
                }else{
                    break
                }
                matchManager.currentPlayer %= matchManager.numberOfPlayers
            }
            matchManager.currentPlayer %= matchManager.numberOfPlayers
        }
        
        if matchManager.currentPlayer < 0{
            matchManager.currentPlayer = (matchManager.numberOfPlayers - 1)
        }else if matchManager.currentPlayer > 4{
            matchManager.currentPlayer = 0
        }

        
        print("currPlayer: \(matchManager.currentPlayer)")
        
      
            matchManager.isDrawing = true
            addTurn = 1
            if matchManager.lastDrawnCard?.value == "+2" || matchManager.lastDrawnCard?.value == "+4" && matchManager.cards[0].count > 0{
                if checkPlusCards() == false{
                    for _ in 0..<matchManager.addedCards{
                        matchManager.cards[matchManager.currentPlayer].append(cardDeck.drawCard())
                    }
                    matchManager.addedCards = 0
                }
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
    
    func getOffset(index: Int) -> CGSize {
        if selectedCard == index {
            return cardOffset
        }
        
        return .zero
    }
    
    func replaceCard(cardIndex: Int){
        //playCardSound()
        if selectedCard != 0{
            selectedCard = selectedCard - 1
        }else{
            selectedCard = 0
        }
        if !matchManager.isStacking && (matchManager.cards[matchManager.currentPlayer][cardIndex]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[matchManager.currentPlayer][cardIndex]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[matchManager.currentPlayer][cardIndex]?.color == "Black")) && matchManager.isDrawing{
            matchManager.lastDrawnCard = matchManager.cards[matchManager.currentPlayer][cardIndex]
            matchManager.isStacking = true
            if matchManager.cards[matchManager.currentPlayer].count > 0{
                matchManager.cards[matchManager.currentPlayer].remove(at: cardIndex)
            }
            if matchManager.cards[matchManager.currentPlayer].count <= 0{
                endTurn()
            }
            
            if matchManager.lastDrawnCard?.value == "Reverse" && matchManager.numberOfPlayers - matchManager.winnerArray.count > 2{
                if !matchManager.oppositeTurn{
                    matchManager.oppositeTurn = true
                }else{
                    matchManager.oppositeTurn = false
                }
            }else if matchManager.lastDrawnCard?.value == "Reverse" && matchManager.numberOfPlayers - matchManager.winnerArray.count <= 2{
                if !matchManager.oppositeTurn{
                    matchManager.oppositeTurn = true
                }else{
                    matchManager.oppositeTurn = false
                }
                addTurn += 1
            }
            else if matchManager.lastDrawnCard?.value == "Skip"{
                addTurn += 1
            }
            
            
            animateCard()

            
        }else if matchManager.isStacking && (matchManager.cards[matchManager.currentPlayer][cardIndex]?.value == matchManager.lastDrawnCard?.value) && matchManager.isDrawing && matchManager.allowStacking{
            matchManager.lastDrawnCard = matchManager.cards[matchManager.currentPlayer][cardIndex]
            
            if matchManager.cards[matchManager.currentPlayer].count > 0{
                matchManager.cards[matchManager.currentPlayer].remove(at: cardIndex)
            }
            if matchManager.cards[matchManager.currentPlayer].count <= 0{
                endTurn()
            }
            
            if matchManager.lastDrawnCard?.value == "Reverse"{
                if !matchManager.oppositeTurn{
                    matchManager.oppositeTurn = true
                }else{
                    matchManager.oppositeTurn = false
                }
            }else if matchManager.lastDrawnCard?.value == "Skip"{
                addTurn += 1
            }
            
            animateCard()
        }
        if matchManager.lastDrawnCard?.value == "+2"{
            matchManager.addedCards += 2
        }else if matchManager.lastDrawnCard?.value == "+4"{
            matchManager.addedCards += 4
        }

    }
    
    func hideCardBtn(){
        if hideCards{
            hideCards = false
        }else{
            hideCards = true
        }
    }
    
    func checkCompatibleCards() -> Bool{
        let cards = matchManager.cards[matchManager.currentPlayer]
        //var hasDrawn = false
        for i in 0..<cards.count {
            if  (matchManager.cards[matchManager.currentPlayer][i]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[matchManager.currentPlayer][i]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[matchManager.currentPlayer][i]?.color == "Black")) && matchManager.isDrawing{
                
                return true
            }
        }
        return false
    }
    
    func checkPlusCards() -> Bool{
        for i in 0..<matchManager.cards[matchManager.currentPlayer].count{
            if matchManager.cards[matchManager.currentPlayer][i]?.value == matchManager.lastDrawnCard?.value{
                return true
            }
        }
        return false
    }
    
    func endTurn(){
        matchManager.isDrawing = false
        
        selectedCard = 0
        
        if matchManager.lastDrawnCard?.color == "Black"{
            showColorChooser = true
        }else{
            hideCards = true
            nextPlayerMenu = true
            nextTurn()
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
    
    func animateCard() {
        
        withAnimation(.easeInOut(duration: 0.5)) {
            cardPosition[matchManager.currentPlayer] = finalPosition
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0)) {
                cardPosition[matchManager.currentPlayer] = defaultPosition[matchManager.currentPlayer]
                matchManager.lastDrawnColor = matchManager.lastDrawnCard?.color ?? "Black"
                
                matchManager.lastDrawnValue =  matchManager.lastDrawnCard?.value ?? "None"
                
            }
        }
        
    }
    
    func playCardSound(){
        guard let soundURL = Bundle.main.url(forResource: "flipcard", withExtension: "mp3") else {
               fatalError("Sound file not found")
           }
           
           do {
               let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
               audioPlayer.play()
               print("played")
           } catch {
               fatalError("Failed to play sound: \(error.localizedDescription)")
           }
    }
    
    
}

struct MultiplayerGameView_Preview: PreviewProvider {
    static var previews: some View {
        MultiplayerGameView(matchManager: MatchManager())
    }
}
