//
//  Roll.swift
//  DiceRoller
//
//  Created by Philipp Sanktjohanser on 31.01.23.
//

import Foundation

struct Roll: Codable, Identifiable {
    var id: String
    let result: Int
    let rolls: [String]
    
    static let example = Roll(id: "\(Date.now)", result: 10, rolls: ["4 + 1", "3 + 2"])
}
