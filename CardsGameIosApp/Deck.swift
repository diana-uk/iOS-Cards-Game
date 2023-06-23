//
//  Deck.swift
//  WarGame
//
//  Created by [Your Name] on [Current Date].
//

import Foundation

class Deck {
    var cards = [Card]()
    
    init() {
        for suit in [Suit.clubs, .diamonds, .hearts, .spades] {
            for rank in Rank.ace.rawValue...Rank.king.rawValue {
                cards.append(Card(suit: suit, rank: Rank(rawValue: rank)!))
            }
        }
    }
    
    // Draw a card from the deck
    func drawCard() -> Card? {
        if !cards.isEmpty {
            return cards.removeFirst()
        } else {
            return nil
        }
    }
    
    // Shuffle the deck
    func shuffleDeck() {
        cards.shuffle()
    }
    
    // Add a card to the bottom of the deck
    func addCard(_ card: Card) {
        cards.append(card)
    }
    
    // Remove all cards from the deck
    func removeAllCards() {
        cards.removeAll()
    }
    
    // Get the count of cards in the deck
    func count() -> Int {
        return cards.count
    }
}
