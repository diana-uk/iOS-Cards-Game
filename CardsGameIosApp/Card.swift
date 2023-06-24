//
//  Card.swift
//  WarGame
//
//  Created by Student15 on 04/06/2023.
//

import Foundation

enum Suit: String {
    case green, blue, pink, yellow
}


enum Rank: Int {
    case watermelon = 1
        case cherry=2, lemon=3, orange=4, banana=5, strawberry=6, ananas=7, kiwi=8, litchi=9, persimmon=10
        case pear=11, grapes=12, peach=13

        var description: String {
            switch self {
            case .watermelon:
                return "watermelon"
            case .pear:
                return "pear"
            case .grapes:
                return "grapes"
            case .peach:
                return "peach"
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
