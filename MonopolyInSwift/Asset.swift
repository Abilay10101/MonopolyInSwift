//
//  Asset.swift
//  MonopolyInSwift
//
//  Created by Arip Khozhbanov on 02.03.2023.
//

import Foundation

class Asset {
    static var allAssets = [Asset]()
    
    let name: String
    let groupColor: String
    let price: Int
    var owner: Player?
    
    private var baseRent: Int
    private var rentMultiplier: Int
    
    init(name: String, groupColor: String, price: Int, baseRent: Int) {
        self.name = name
        self.groupColor = groupColor
        self.price = price
        self.baseRent = baseRent
        self.rentMultiplier = 1
        
        Asset.allAssets.append(self)
    }
    
    var rent: Int {
        return baseRent * rentMultiplier
    }
    
    func increaseRentMultiplier() {
        rentMultiplier *= 3
    }
}
