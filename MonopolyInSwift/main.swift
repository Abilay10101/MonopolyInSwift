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

print("Write name of players:")

var players = [Player]()
for _ in 1...numberOfPlayers {
    let playerName = readLine()!
    let player = Player(name: playerName, balance: 2000000, position: 0)
    players.append(player)
}

// Создание активов
let start = Asset(name: "Start", groupColor: "None", price: 0, baseRent: 0)

let asset1 = Asset(name: "Fork", groupColor: "Red", price: 100000, baseRent: 10000)
let asset2 = Asset(name: "Telegram", groupColor: "Red", price: 100000, baseRent: 10000)
let asset3 = Asset(name: "Google", groupColor: "Red", price: 100000, baseRent: 10000)

let chanceCart = Asset(name: "ChanceCart", groupColor: "None", price: 0, baseRent: 0)

let asset4 = Asset(name: "Notion", groupColor: "Blue", price: 150000, baseRent: 15000)
let asset5 = Asset(name: "Bear", groupColor: "Blue", price: 150000, baseRent: 15000)
let asset6 = Asset(name: "Yandex", groupColor: "Blue", price: 150000, baseRent: 15000)

let chanceCart2 = Asset(name: "ChanceCart", groupColor: "None", price: 0, baseRent: 0)

let asset7 = Asset(name: "Kolesa", groupColor: "Green", price: 200000, baseRent: 20000)
let asset8 = Asset(name: "Zapis.kz", groupColor: "Green", price: 200000, baseRent: 20000)
let asset9 = Asset(name: "Kaspi.kz", groupColor: "Green", price: 200000, baseRent: 20000)

let jail = Asset(name: "Jail", groupColor: "None", price: 0, baseRent: 0)

let asset10 = Asset(name: "Tesla", groupColor: "Purple", price: 250000, baseRent: 25000)
let asset11 = Asset(name: "Ford", groupColor: "Purple", price: 250000, baseRent: 25000)
let asset12 = Asset(name: "Ferrari", groupColor: "Purple", price: 250000, baseRent: 25000)

let chanceCart3 = Asset(name: "ChanceCart", groupColor: "None", price: 0, baseRent: 0)

let asset13 = Asset(name: "Apple", groupColor: "Yellow", price: 300000, baseRent: 30000)
let asset14 = Asset(name: "Samsung", groupColor: "Yellow", price: 300000, baseRent: 30000)
let asset15 = Asset(name: "Xiaomi", groupColor: "Yellow", price: 300000, baseRent: 30000)

let freeParking = Asset(name: "Free Parking", groupColor: "None", price: 0, baseRent: 0)

let asset16 = Asset(name: "nFactorial 1", groupColor: "Brown", price: 350000, baseRent: 35000)
let asset17 = Asset(name: "nFactorial 2", groupColor: "Brown", price: 350000, baseRent: 35000)
let asset18 = Asset(name: "nFactorial 3", groupColor: "Brown", price: 350000, baseRent: 35000)



while players.filter({ $0.balance > 0 }).count > 1 {
    for player in players {
        
        let chanceCards = [
            ChanceCard(description: "Bank pays you dividend of 1000t", moveSpaces: 0, balanceChange: 1000, moveToPosition: nil),
            ChanceCard(description: "Pay hospital fees of 1000000t", moveSpaces: 0, balanceChange: -1000000, moveToPosition: nil)
        ].shuffled()
        
        let diceRoll = Int.random(in: 1...6)
        player.move(numberOfSpaces: diceRoll)
        
        if player.isInJail {
            print("\(player.name) is in jail.")
            if player.jailRolls >= 3 {
                print("\(player.name) has been in jail for three turns and must pay 3000000t to get out.")
                player.balance -= 3000000
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
            
            if (player.position > Asset.allAssets.count) {
                print("\(player.name) made circle he earns +500 000t")
                player.position = player.position % Asset.allAssets.count
                player.balance += 500000
            }
            
            if currentAsset.name == "Start" {
                print("\(player.name) landed on \(currentAsset.name)")
            }
            else if currentAsset.owner == nil && currentAsset.name == "ChanceCart" {
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
