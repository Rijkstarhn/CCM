//
//  Category.swift
//  CCM
//
//  Created by Rexxay on 2024-12-18.
//

// Category.swift
import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var icon: String // SF Symbol name
}
