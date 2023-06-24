import Foundation

import SwiftUI
import CoreData

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var playerName: String = ""
    @State private var selectedImage: String = "red"
    @State private var player1Points: Int = 0
    @State private var player2Points: Int = 0
    @State private var rounds: Int = 0
    @State private var isWar: Bool = false
    @State private var deck: Deck = Deck()
    @State private var card1: Card = Card(suit: Suit.yellow, rank: Rank.watermelon)
    @State private var card2: Card = Card(suit: Suit.pink, rank: Rank.watermelon)
    @State var timer: Timer? = nil

    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            HStack{
                Text("\(self.selectedImage != "red" ? playerName : "PC")")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
                .padding()
                Spacer()
                Text("\(isWar ? "War!" : "")")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
                .padding()
                Spacer()
                Text("\(self.selectedImage == "red" ? playerName : "PC")")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
                .padding()
                
            }
            HStack {
                Text("Points: \(player1Points)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding()
                Spacer()
                Text("Points: \(player2Points)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding()
            }
            
            HStack {
                CardImage(card: card1, isSelected: selectedImage == "green") {
                    selectedImage = "green"
                    saveUserDefaults()
                }
                Spacer()
                CardImage(card: card2, isSelected: selectedImage == "red") {
                    selectedImage = "red"
                    saveUserDefaults()
                }
            }
            .padding([.leading, .trailing])
            
            if rounds > 10 {
                NavigationLink(destination: ResultsView()) {
                    Text("Next")
                        .font(.system(size: 24, weight: .semibold))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10, x: 2, y: 0)
                    }
            }
        }
        .padding()
        .onAppear(perform: setupGame)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .background(
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func setupGame() {
        loadUserDefaults()
        let shouldRestart: Bool = navBack()
        if !shouldRestart {
            deck = Deck()
            deck.shuffleDeck()
            timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                game()
            }
        }
    }
    
    func game() {
        if rounds > 10 {
            timer?.invalidate()
            timer = nil
            saveUserDefaults()
            return
        }
        
        card1 = deck.drawCard() ?? Card(suit: Suit.yellow, rank: Rank.watermelon)
        card2 = deck.drawCard() ?? Card(suit: Suit.pink, rank: Rank.watermelon)
        
        if card1.rank == card2.rank && !(player1Points == 0 && player2Points == 0) {
            isWar = true
        } else {
            var player1Won = card1.rank.rawValue >= card2.rank.rawValue
            player1Won = player1Won || card1.rank.rawValue == 1
            if card2.rank.rawValue == 1 {
                player1Won = false
            }
            
            var points = 1
            if isWar {
                points += 2
            }
            
            if player1Won {
                player1Points += points
            } else {
                player2Points += points
            }
            
            isWar = false
            rounds += 1
        }
    }
    
    func saveUserDefaults() {
        defaults.set(playerName, forKey: "playerName")
        defaults.set(selectedImage, forKey: "selectedImage")
        defaults.set(player1Points > player2Points ? "PC" : playerName, forKey: "winnerName")
    }
    
    func loadUserDefaults() {
        playerName = defaults.string(forKey: "playerName") ?? ""
        selectedImage = defaults.string(forKey: "selectedImage") ?? "red"
    }
    
    func navBack() -> Bool {
        if GlobalState.shouldNavigateBack {
            GlobalState.shouldNavigateBack = false
            presentationMode.wrappedValue.dismiss()
            return true
        }
        return false
    }
}

struct CardImage: View {
    let card: Card
    let isSelected: Bool
    let onTap: () -> Void
    
    
    
    var body: some View {
        Image("\(card.suit)_\(card.rank)")
            .resizable()
            .aspectRatio(9/10, contentMode: .fit)
            .frame(maxWidth: 200)
            .shadow(color: isSelected ? .white : .clear, radius: 10)
            .onTapGesture(perform: onTap)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
