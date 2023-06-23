//
//  Card.swift
//  WarGame
//
//  Created by [Your Name] on [Current Date].
//

import Foundation

enum Suit: String {
    case clubs, diamonds, hearts, spades
}

enum Rank: Int {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    var description: String {
        switch self {
        case .ace:
            return "Ace"
        case .jack:
            return "Jack"
        case .queen:
            return "Queen"
        case .king:
            return "King"
        default:
            return "\(rawValue)"
        }
    }
}

class Card {
    var suit: Suit
    var rank: Rank
    
    init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
    
    var description: String {
        return "\(rank.description) of \(suit.rawValue.capitalized)"
    }
}
