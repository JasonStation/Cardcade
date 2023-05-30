import SwiftUI
import SpriteKit
import AVFoundation

struct GameView: View {
    @State private var orientation = UIDeviceOrientation.unknown
    
    @ObservedObject var matchManager: MatchManager
    
    @State private var selectedCard = 0
    @State private var cardOffset: CGSize = .zero
    
    @State private var defaultPosition = [
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: -100, y: UIScreen.main.bounds.height / 2 - 180),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: -180),
        CGPoint(x: UIScreen.main.bounds.width + 100, y: UIScreen.main.bounds.height / 2 - 180)]
    
    @State private var cardPosition = [
        CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + 100),
        CGPoint(x: -100, y: UIScreen.main.bounds.height / 2 - 180),
        CGPoint(x: UIScreen.main.bounds.width / 2, y: -180),
        CGPoint(x: UIScreen.main.bounds.width + 100, y: UIScreen.main.bounds.height / 2 - 180)]
    
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
    
    @State private var winnerStatus = [false, false, false, false]
    
    @State private var positions = ["1st", "2nd", "3rd", "4th"]
    @State private var winnerIndex = 0
    @State private var winnerMenu = false

    @State private var gameOver = false
    
    @State private var menuOptions = false
    
    //var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        if !gameOver{
            ZStack{
                
    
                VStack (alignment: .center) {
                    
                    Spacer()
                    HStack{
                        ZStack{
                            
                            //Player 2 Stack
                            
                            VStack(spacing: -300){
                                ForEach(matchManager.cards[1].indices.prefix(30), id: \.self) { index in
                                    Rectangle()
                                        .fill(Color.cyan)
                                        .frame(width: opponentCardHeight, height: opponentCardWidth)
                                        .cornerRadius(10)
                                    
                                        .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                        .position(x: 0, y: UIScreen.main.bounds.width / 2.5)
                                }
                            }
                                HStack{
                                    Text("\(matchManager.playerNames[1])")
                                    //  .font(.title)
                                    
                                    if matchManager.cards[1].count > 0{
                                        Text("\(matchManager.cards[1].count)")
                                            .font(.title)
                                            .bold()
                                    }else{
                                        Text("\(matchManager.winnerPos[1])")
                                            .font(.title)
                                            .bold()
                                    }
                                }
                                .padding()
                                .background(matchManager.currentPlayer == 1 ? .yellow : .white)
                                .cornerRadius(15)
                                .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                .position(x: UIScreen.main.bounds.width / 5, y: UIScreen.main.bounds.width / 1.07)
                            
                            
                            //Player 3 Stack
                            
                            if matchManager.numberOfPlayers >= 3{
                                HStack(spacing: -300){
                                    ForEach(matchManager.cards[2].indices.prefix(30), id: \.self) { index in
                                        Rectangle()
                                            .fill(Color.cyan)
                                            .frame(width: opponentCardWidth, height: opponentCardHeight)
                                            .cornerRadius(10)
                                        
                                            .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                            .position(x: UIScreen.main.bounds.width / 2.5, y: 0)
                                    }
                                }
                                
                                HStack{
                                    Text("\(matchManager.playerNames[2])")
                                    //  .font(.title)
                                    
                                    if matchManager.cards[2].count > 0{
                                        Text("\(matchManager.cards[2].count)")
                                            .font(.title)
                                            .bold()
                                    }else{
                                        Text("\(matchManager.winnerPos[2])")
                                            .font(.title)
                                            .bold()
                                    }
                                    
                                }
                                .padding()
                                .background(matchManager.currentPlayer == 2 ? .yellow : .white)
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
                            
                            //Player 4 Stack
                            
                            if matchManager.numberOfPlayers >= 4{
                                VStack(spacing: -300){
                                    ForEach(matchManager.cards[3].indices.prefix(30), id: \.self) { index in
                                        Rectangle()
                                            .fill(Color.cyan)
                                            .frame(width: opponentCardHeight, height: opponentCardWidth)
                                            .cornerRadius(10)
                                        
                                            .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                            .position(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.width / 2.5)
                                    }
                                }
                                
                                HStack{
                                    Text("\(matchManager.playerNames[3])")
                                    //  .font(.title)
                                    
                                    if matchManager.cards[3].count > 0{
                                        Text("\(matchManager.cards[3].count)")
                                            .font(.title)
                                            .bold()
                                    }else{
                                        Text("\(matchManager.winnerPos[3])")
                                            .font(.title)
                                            .bold()
                                    }
                                    
                                }
                                .padding()
                                .background(matchManager.currentPlayer == 3 ? .yellow : .white)
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
                            }
                            
                        }
                    }
                    
                    
                    Spacer()
                    
                    if matchManager.cards[0].count > 0{
                        HStack{
                            Text("Your cards (\(matchManager.cards[0].count))")
                                .font(.title).bold().padding(.horizontal)
                            Spacer()
                            
                            if matchManager.isDrawing && matchManager.isStacking{
                                Button(action: {
                                    endTurn()
                                    
                                }) {
                                    Text("End turn")
                                        .font(.system(size: 22, weight: .bold)) .frame(width: 120, height: 60)
                                        .foregroundColor(.white)
                                        .background(.red)
                                        .cornerRadius(30)
                                }.padding(.horizontal)
                            }
                        
                        }
                    
                        
                        //Player cards
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(matchManager.cards[0].indices, id: \.self) { index in
                                    ZStack{
                                        Rectangle()
                                            .fill(getColor(color: matchManager.cards[0][index]?.color ?? "Black"))
                                            .frame(width: cardWidth, height: cardHeight)
                                            .cornerRadius(10)
                                            .padding(6)
                                            .offset(getOffset(index: index))
                                            .shadow(color: selectedCard == index && matchManager.isDrawing ? .gray : .clear, radius: 6, x: 0, y: 4)
                                            .blur(radius: selectedCard == index && matchManager.isDrawing ? 4 : 0)
                                            .opacity(matchManager.isDrawing ? 1 : 0.4)
                                        
                                        
                                        if matchManager.cards[0][index]?.value == "Skip" || matchManager.cards[0][index]?.value == "Reverse" || matchManager.cards[0][index]?.value == "+2" || matchManager.cards[0][index]?.value == "+4" || matchManager.cards[0][index]?.value == "Wild"{
                                            getCardIcon(value: matchManager.cards[0][index]?.value ?? "")
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                        }else{
                                            Text(matchManager.cards[0][index]?.value ?? "None")
                                                .font(.title).bold()
                                                .foregroundColor(.white)
                                                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                                            
                                            
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
                            
                            //                if !matchManager.isStacking && checkCompatibleCards() == false{
                            //                    Button(action: {
                            //                        matchManager.cards.insert(cardDeck.drawCard(), at: 0)
                            //                        nextTurn()
                            //
                            //                    }) {
                            //                        Text("Take Card from Deck")
                            //                            .font(.system(size: 25, weight: .bold)) .frame(width: 300, height: 60)
                            //                            .foregroundColor(.white)
                            //                            .background(.orange)
                            //                            .cornerRadius(30)
                            //                    }
                            //                }
                            //                else{
                            if !matchManager.isStacking && (matchManager.cards[0][selectedCard]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[0][selectedCard]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[0][selectedCard]?.color == "Black")) && matchManager.isDrawing {
                                Button(action: {
                                    replaceCard(cardIndex: selectedCard)
                                    
                                }) {
                                    Text("Play card")
                                        .font(.system(size: 25, weight: .bold)) .frame(width: 200, height: 60)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .cornerRadius(30)
                                }
                            }else if matchManager.isStacking && (matchManager.cards[0][selectedCard]?.value == matchManager.lastDrawnCard?.value)  && matchManager.isDrawing && matchManager.allowStacking{
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
                                        && checkCompatibleCards() == false && matchManager.currentPlayer == 0
                            {
                                Button(action: {
                                    matchManager.cards[0].insert(cardDeck.drawCard(), at: 0)
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
                        Text("\(matchManager.winnerPos[0]) place")
                            .font(.title)
                            .bold()
                            .foregroundColor(.gray)
                        Text("You ran out of cards!")
                            .font(.title)
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
                                chosenColor(index: colorChooserIndex)
                                showColorChooser = false
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
            opposite = -1
        }
        
        matchManager.isStacking = false
        //matchManager.currentPlayer += (addTurn * opposite)
        
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
        
        if matchManager.currentPlayer == 0{
            matchManager.isDrawing = true
            addTurn = 1
            if matchManager.lastDrawnCard?.value == "+2" || matchManager.lastDrawnCard?.value == "+4"  && matchManager.cards[0].count > 0{
                if checkPlusCards() == false{
                    for _ in 0..<matchManager.addedCards{
                        matchManager.cards[0].append(cardDeck.drawCard())
                    }
                    matchManager.addedCards = 0
                }
            }
        }
        else{
            addTurn = 1
            botCardDraw(botNumber: matchManager.currentPlayer)
        }
    }
    
    func botCardDraw(botNumber: Int) {
        
        if matchManager.cards[botNumber].count <= 0{
            nextTurn()
            return
        }
        
        var hasCompatibleCard = false
        var hasDrawn = false
        
        if matchManager.lastDrawnCard?.value == "+2" || matchManager.lastDrawnCard?.value == "+4"{
            for i in 0..<matchManager.cards[botNumber].count{
                if matchManager.cards[botNumber][i]?.value == matchManager.lastDrawnCard?.value{
                    matchManager.lastDrawnCard = matchManager.cards[botNumber][i]
                    matchManager.isStacking = true
                    matchManager.cards[botNumber].remove(at: i)
                    animateCard()
                    hasDrawn = true
                    hasCompatibleCard = true
                    if matchManager.lastDrawnCard?.color == "Black"{
                        let randomIndex = Int.random(in: 0..<4)
                        matchManager.lastDrawnCard?.color = colorChooser[randomIndex]
                    }
                    if matchManager.lastDrawnCard?.value == "+2"{
                        matchManager.addedCards += 2
                    }else if matchManager.lastDrawnCard?.value == "+4"{
                        matchManager.addedCards += 4
                    }
                    break
                }
            }
            if !hasCompatibleCard{
                for _ in 0..<matchManager.addedCards{
                    matchManager.cards[botNumber].append(cardDeck.drawCard())
                }
                matchManager.addedCards = 0
            }
        }
        
        for i in 0..<matchManager.cards[botNumber].count {
            if !matchManager.isStacking && (matchManager.cards[botNumber][i]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[botNumber][i]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[botNumber][i]?.color == "Black")) {
                matchManager.lastDrawnCard = matchManager.cards[botNumber][i]
                matchManager.isStacking = true
                matchManager.cards[botNumber].remove(at: i)
                animateCard()
                hasDrawn = true
                
            
                
                if matchManager.lastDrawnCard?.value == "+2"{
                    matchManager.addedCards += 2
                }else if matchManager.lastDrawnCard?.value == "+4"{
                    matchManager.addedCards += 4
                }
                
                if matchManager.lastDrawnCard?.color == "Black"{
                    let randomIndex = Int.random(in: 0..<4)
                    matchManager.lastDrawnCard?.color = colorChooser[randomIndex]
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
                
                break
            } else if matchManager.isStacking && (matchManager.cards[botNumber][i]?.value == matchManager.lastDrawnCard?.value) {
                matchManager.lastDrawnCard = matchManager.cards[botNumber][i]
                matchManager.cards[botNumber].remove(at: i)
                animateCard()
                hasDrawn = true
                if matchManager.lastDrawnCard?.color == "Black"{
                    let randomIndex = Int.random(in: 0..<4)
                    matchManager.lastDrawnCard?.color = colorChooser[randomIndex]
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
                
                break
            }
        }
        
        if !hasDrawn{
            matchManager.cards[botNumber].append(cardDeck.drawCard())
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            nextTurn()
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
        if !matchManager.isStacking && (matchManager.cards[0][cardIndex]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[0][cardIndex]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[0][cardIndex]?.color == "Black")) && matchManager.isDrawing{
            matchManager.lastDrawnCard = matchManager.cards[0][cardIndex]
            matchManager.isStacking = true
            if matchManager.cards[0].count > 0{
                matchManager.cards[0].remove(at: cardIndex)
            }
            if matchManager.cards[0].count <= 0{
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

            
        }else if matchManager.isStacking && (matchManager.cards[0][cardIndex]?.value == matchManager.lastDrawnCard?.value) && matchManager.isDrawing && matchManager.allowStacking{
            matchManager.lastDrawnCard = matchManager.cards[0][cardIndex]
            
            if matchManager.cards[0].count > 0{
                matchManager.cards[0].remove(at: cardIndex)
            }
            if matchManager.cards[0].count <= 0{
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
    
    func checkCompatibleCards() -> Bool{
        let cards = matchManager.cards[0]
        //var hasDrawn = false
        for i in 0..<cards.count {
            if  (matchManager.cards[0][i]?.color == matchManager.lastDrawnCard?.color || matchManager.cards[0][i]?.value == matchManager.lastDrawnCard?.value || (matchManager.cards[0][i]?.color == "Black")) && matchManager.isDrawing{
                
                return true
            }
        }
        return false
    }
    
    func checkPlusCards() -> Bool{
        for i in 0..<matchManager.cards[0].count{
            if matchManager.cards[0][i]?.value == matchManager.lastDrawnCard?.value{
                return true
            }
        }
        return false
    }
    
    func endTurn(){
        matchManager.isDrawing = false
        
        if matchManager.lastDrawnCard?.color == "Black"{
            showColorChooser = true
        }else{
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(matchManager: MatchManager())
    }
}
