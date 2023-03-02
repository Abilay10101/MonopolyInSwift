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
    let player = Player(name: playerName, balance: 1500000, position: 0)
    players.append(player)
}

// Создание активов
let asset1 = Asset(name: "Asset 1", groupColor: "Red", price: 150000, baseRent: 10000)
let asset2 = Asset(name: "Asset 2", groupColor: "Red", price: 150000, baseRent: 15000)
let asset3 = Asset(name: "Asset 3", groupColor: "Red", price: 150000, baseRent: 15000)
let chanceCart = Asset(name: "ChanceCart", groupColor: "None", price: 0, baseRent: 0)
let jail = Asset(name: "Jail", groupColor: "None", price: 0, baseRent: 0)
let freeParking = Asset(name: "Free Parking", groupColor: "None", price: 0, baseRent: 0)
let asset5 = Asset(name: "Asset 5", groupColor: "Red", price: 150000, baseRent: 15000)

let jailPosition = Asset.allAssets.firstIndex(where: { $0.name == "Jail" })!

while players.filter({ $0.balance > 0 }).count > 1 {
    for player in players {
        
        let chanceCards = [
            ChanceCard(description: "Advance to Go", moveSpaces: 0 - player.position, balanceChange: 0, moveToPosition: 0),
            ChanceCard(description: "Bank pays you dividend of $500", moveSpaces: 0, balanceChange: 500, moveToPosition: nil),
            ChanceCard(description: "Pay hospital fees of $1000", moveSpaces: 0, balanceChange: -1000, moveToPosition: nil)
        ].shuffled()
        
        let diceRoll = Int.random(in: 1...6)
        player.move(numberOfSpaces: diceRoll)
        
        if player.isInJail {
            print("\(player.name) is in jail.")
            if player.jailRolls >= 3 {
                print("\(player.name) has been in jail for three turns and must pay $50 to get out.")
                player.balance -= 50
                player.isInJail = false
                player.jailRolls = 0
            } else {
                let roll1 = Int.random(in: 1...6)
                let roll2 = Int.random(in: 1...6)
                print("\(player.name) rolled a \(roll1) and a \(roll2).")
                if roll1 == roll2 {
                    print("\(player.name) rolled doubles and is now out of jail.")
                    player.isInJail = false
                    player.jailRolls = 0
                    player.position += roll1 + roll2
                } else {
                    print("\(player.name) did not roll doubles and must stay in jail.")
                    player.jailRolls += 1
                }
            }
        } else  {
            let currentAsset = Asset.allAssets[player.position % Asset.allAssets.count]

            if currentAsset.owner == nil && currentAsset.name == "ChanceCart" {
                print("\(player.name) landed on \(currentAsset.name)")
                print(chanceCards[0].description)
                player.position += chanceCards[0].moveSpaces
                player.balance += chanceCards[0].balanceChange
            }
            else if currentAsset.name == "Jail" {
                print("\(player.name) landed on \(currentAsset.name)")
                player.isInJail = true
            }
            else if currentAsset.name == "Free Parking" {
                print("\(player.name) landed on \(currentAsset.name)")
            }
            else if currentAsset.owner == nil {
                print("\(player.name) landed on \(currentAsset.name)")
                print("Would you like to buy \(currentAsset.name) for \(currentAsset.price)? (y/n)")
                if let input = readLine(), input.lowercased() == "y" {
                    player.buy(asset: currentAsset)
                }
            } else  {
                print("\(player.name) landed on \(currentAsset.name) which is owned by \(currentAsset.owner!.name)")
                player.payRent(asset: currentAsset)
                
                if player.balance <= 0 {
                    print("\(player.name) is bankrupt and out of the game.")
                    if let index = players.firstIndex(where: { $0 === player }) {
                        players.remove(at: index)
                    }
                }
                
            }
        }
    }
}
print("Winner is \(players[0].name)")
