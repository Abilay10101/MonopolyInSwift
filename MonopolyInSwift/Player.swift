//
//  Player.swift
//  MonopolyInSwift
//
//  Created by Arip Khozhbanov on 02.03.2023.
//

import Foundation

class Player {
    var name: String
    var balance: Int
    var position: Int
    var isInJail: Bool = false
    var jailRolls: Int = 0
    
    init(name: String, balance: Int, position: Int) {
        self.name = name
        self.balance = balance
        self.position = position
    }
    
    func move(numberOfSpaces: Int) {
        position += numberOfSpaces
    }
    
    func buy(asset: Asset) {
        if balance >= asset.price {
            balance -= asset.price
            asset.owner = self
        } else {
            print("Not enough money to buy this asset")
        }
    }
    
    func payRent(asset: Asset) {
        if balance > asset.rent {
            balance -= asset.rent
            asset.owner!.balance += asset.rent
        } else {
            print("Not enough money to pay rent to \(asset.owner!.name)")
            bankrupt()
            balance = 0
        }
    }
    
    func bankrupt() {
        //print("\(name) is bankrupt!")
        
        for asset in Asset.allAssets {
            if asset.owner === self {
                asset.owner = nil
            }
        }
    }
}
