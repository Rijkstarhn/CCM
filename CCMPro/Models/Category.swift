//
//  Category.swift
//  CCMPro
//
//  Created by Rexxay on 2024-12-20.
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    var name: String
    var bestCard: Card?
}
