//
//  Card.swift
//  flight
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var cardImage: String
}

var sampleCards: [Card] = [
    .init(cardImage: "Card 1"),
    .init(cardImage: "Card 2"),
    .init(cardImage: "Card 3"),
    .init(cardImage: "Card 4"),
    .init(cardImage: "Card 5"),
    .init(cardImage: "Card 6"),
    .init(cardImage: "Card 7"),
    .init(cardImage: "Card 8"),
    .init(cardImage: "Card 9"),
    .init(cardImage: "Card 10"),
]
