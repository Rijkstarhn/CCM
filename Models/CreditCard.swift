//
//  CreditCard.swift
//  CCM
//
//  Created by Rexxay on 2024-12-18.
//

import Foundation

struct CreditCard: Identifiable, Codable {
    var id = UUID()
    var name: String
    var cashbackRates: [Category: Double]
}
