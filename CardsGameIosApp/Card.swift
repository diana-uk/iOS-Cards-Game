//
//  Card.swift
//  WarGame
//
//  Created by Student15 on 04/06/2023.
//

import Foundation

enum Suit: String {
    case clubs, diamonds, hearts, spades
}


enum Rank: Int {
    case ace = 1
        case two=2, three=3, four=4, five=5, six=6, seven=7, eight=8, nine=9, ten=10
        case jack=11, queen=12, king=13

        var description: String {
            switch self {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
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
        return "\(rank) of \(suit)"
    }
}
