//
//  ContentView.swift
//  MyWarGameApp
//
//  Created by Student15 on 04/06/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var currentView: String? = nil
    @State private var playerName: String = ""
    @State private var selectedImage: String? = "red"
    @State private var showRedShadow: Bool = false
    let defaults = UserDefaults.standard
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Card Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .padding()
                HStack {
                    Image("ace_of_spades")
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(maxWidth: 200)
                        .shadow(color: selectedImage == "green" ? Color.white : Color.clear, radius: 10)
                        .onTapGesture {
                            self.selectedImage = "green"
                            saveUserDefaults()
                        }
                    Spacer()
                    VStack {
                        Text("Pick your color")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            .padding()
                        Spacer()
                        Text("User's Longitude: \(locationManager.userLongitude ?? 0)")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            .padding()
                    }
                    Spacer()
                    Image("ace_of_hearts")
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(maxWidth: 200)
                        .shadow(color: selectedImage == "red" ? Color.white : Color.clear, radius: 10)
                        .onTapGesture {
                            self.selectedImage = "red"
                            saveUserDefaults()
                        }
                }
                .padding([.leading, .trailing])
                
                TextField("Enter your name", text: $playerName)
                    .font(.title2)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .shadow(color: showRedShadow ? .red : .clear, radius: 2)
                    .onChange(of: playerName) { newValue in
                        saveUserDefaults()
                    }
                
                NavigationLink(destination: SecondView()) {
                    Text("Start Game")
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 10, x: 2, y: 0)
                }
            }
            .padding()
            .onAppear(perform: loadUserDefaults)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    func saveUserDefaults() {
        defaults.set(playerName, forKey: "playerName")
        defaults.set(selectedImage, forKey: "selectedImage")
    }

    func loadUserDefaults() {
        playerName = defaults.string(forKey: "playerName") ?? ""
        selectedImage = defaults.string(forKey: "selectedImage") ?? "red"
    }
}

struct GlobalState {
    static var shouldNavigateBack: Bool = false
}

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var playerName: String = ""
    @State private var selectedImage: String = "red"
    @State private var player1Points: Int = 0
    @State private var player2Points: Int = 0
    @State private var rounds: Int = 0
    @State private var isWar: Bool = false
    @State private var deck: Deck = Deck()
    @State private var card1: Card = Card(suit: Suit.spades, rank: Rank.ace)
    @State private var card2: Card = Card(suit: Suit.hearts, rank: Rank.ace)
    @State var timer: Timer? = nil

    let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            HStack {
                Text("\(playerName.isEmpty ? "Rival" : playerName)")
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
                Text("\(playerName.isEmpty ? "Rival" : playerName)")
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
                NavigationLink(destination: ThirdView()) {
                    Text("Next")
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.black)
                        .cornerRadius(10)
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
        
        card1 = deck.drawCard() ?? Card(suit: Suit.spades, rank: Rank.ace)
        card2 = deck.drawCard() ?? Card(suit: Suit.hearts, rank: Rank.ace)
        
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
        defaults.set(player1Points > player2Points ? "Rival" : playerName, forKey: "winnerName")
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
        Image("\(card.rank.description)_of_\(card.suit)")
            .resizable()
            .aspectRatio(9/16, contentMode: .fit)
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
struct ThirdView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var winnerName: String = ""
    let defaults = UserDefaults.standard
    
    
    var body: some View {
        VStack {

            Text("\(winnerName) wins the war!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
                .padding()
            
            Spacer()
            
            Button(action: {
                GlobalState.shouldNavigateBack = true
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Go back to First View")
            }
        }
        .padding()
        .onAppear(perform: loadUserDefaults)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func loadUserDefaults() {
        winnerName = defaults.string(forKey: "winnerName") ?? "Rival"
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



