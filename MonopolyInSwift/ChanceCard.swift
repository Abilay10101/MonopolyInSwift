//
//  ChanceCard.swift
//  MonopolyInSwift
//
//  Created by Arip Khozhbanov on 02.03.2023.
//

import Foundation

class ChanceCard {
    
    let description: String
    let moveSpaces: Int
    let balanceChange: Int
    let moveToPosition: Int?

    init(description: String, moveSpaces: Int, balanceChange: Int, moveToPosition: Int?) {
        self.description = description
        self.moveSpaces = moveSpaces
        self.balanceChange = balanceChange
        self.moveToPosition = moveToPosition
    }
    
}
