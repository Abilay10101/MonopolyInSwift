//
//  main.swift
//  MonopolyInSwift
//
//  Created by Arip Khozhbanov on 02.03.2023.
//

import Foundation

// Создание игроков
let player1 = Player(name: "Player 1", balance: 2000000, position: 0)
let player2 = Player(name: "Player 2", balance: 2000000, position: 0)

// Создание активов
let asset1 = Asset(name: "Asset 1", groupColor: "Red", price: 100000, baseRent: 10000)
let asset2 = Asset(name: "Asset 2", groupColor: "Red", price: 150000, baseRent: 15000)


while true {
    
    let diceRoll = Int.random(in: 1...6)
    player1.move(numberOfSpaces: diceRoll)
    
    if player1.position == 0 {
        player1.balance += 500000
    } else {
        let currentAsset = Asset.allAssets[player1.position]
        
        if currentAsset.owner == nil {
            
            player1.buy(asset: currentAsset)
        } else if currentAsset.owner === player2 {
           
            player1.payRent(asset: currentAsset)
        }
    }
    
    // Ход игрока 2
    let diceRoll2 = Int.random(in: 1...6)
    player2.move(numberOfSpaces: diceRoll2)

    if player2.position == 0 {
        player2.balance += 500000
    } else {
        let currentAsset = Asset.allAssets[player2.position]
        
        if currentAsset.owner == nil {
          
            player2.buy(asset: currentAsset)
        } else if currentAsset.owner === player1 {
            
            player2.payRent(asset: currentAsset)
        }
    }
    
    
}
