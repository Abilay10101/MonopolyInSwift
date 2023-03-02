//
//  main.swift
//  MonopolyInSwift
//
//  Created by Arip Khozhbanov on 02.03.2023.
//

import Foundation

var numberOfPlayers = 0
while numberOfPlayers < 2 || numberOfPlayers > 4 {
    print("Enter the number of players (2-4): ")
    if let input = readLine(), let inputInt = Int(input) {
        numberOfPlayers = inputInt
    } else {
        print("Invalid input")
    }
}

// Создание игроков
var players = [Player]()
for i in 1...numberOfPlayers {
    let playerName = "Player \(i)"
    let player = Player(name: playerName, balance: 150000, position: 0)
    players.append(player)
}

// Создание активов
let asset1 = Asset(name: "Asset 1", groupColor: "Red", price: 150000, baseRent: 10000)
let asset2 = Asset(name: "Asset 2", groupColor: "Red", price: 150000, baseRent: 15000)
let asset3 = Asset(name: "Asset 3", groupColor: "Red", price: 150000, baseRent: 15000)
let asset4 = Asset(name: "Asset 4", groupColor: "Red", price: 150000, baseRent: 15000)
let asset5 = Asset(name: "Asset 5", groupColor: "Red", price: 150000, baseRent: 15000)


while players.filter({ $0.balance > 0 }).count > 1 {
    for player in players {
        
        if (players.count == 1) {
            print("Winner is \(player.name)")
            break
        }
        
        let diceRoll = Int.random(in: 2...6)
        player.move(numberOfSpaces: diceRoll)

        if player.position == 0 {
            player.balance += 500000
        } else  {
            let currentAsset = Asset.allAssets[player.position % Asset.allAssets.count]

            if currentAsset.owner == nil {
                // Свободный актив
                print("\(player.name) landed on \(currentAsset.name)")
                print("Would you like to buy \(currentAsset.name) for \(currentAsset.price)? (y/n)")
                if let input = readLine(), input.lowercased() == "y" {
                    player.buy(asset: currentAsset)
                }
            } else  {
                // Актив, принадлежащий другому игроку
                print("\(player.name) landed on \(currentAsset.name) which is owned by \(currentAsset.owner!.name)")
                player.payRent(asset: currentAsset)
                if player.balance <= 0 {
                    players.removeAll(where: { $0 === player })
                }
            }
        }
    }
}
print("Winner is \(players[0].name)")
