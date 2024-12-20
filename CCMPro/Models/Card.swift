//
//  Card.swift
//  CCMPro
//
//  Created by Rexxay on 2024-12-20.
//
import Foundation

struct Card: Identifiable {
    let id = UUID()
    var name: String
    var rewards: [String: Double] // Key: Category, Value: Cashback percentage
}
