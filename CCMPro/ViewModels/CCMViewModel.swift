//
//  CCMViewModel.swift
//  CCMPro
//
//  Created by Rexxay on 2024-12-20.
//

import Foundation

class CCMViewModel: ObservableObject {
    @Published var categories: [Category] = [
        Category(name: "Dining", bestCard: nil),
        Category(name: "Groceries", bestCard: nil),
        Category(name: "Gas", bestCard: nil),
        Category(name: "Travel", bestCard: nil),
        Category(name: "Online Shopping", bestCard: nil),
        Category(name: "Pharmacy", bestCard: nil),
        Category(name: "Rent", bestCard: nil)
    ]
    @Published var cards: [Card] = []
    
    func addCategory(name: String) {
        categories.append(Category(name: name, bestCard: nil))
    }
    
    func addCard(name: String, rewards: [String: Double]) {
        cards.append(Card(name: name, rewards: rewards))
    }
    
    func updateBestCards() {
        for i in 0..<categories.count {
            if let bestCard = cards.max(by: {
                ($0.rewards[categories[i].name] ?? 0) < ($1.rewards[categories[i].name] ?? 0)
            }) {
                categories[i].bestCard = bestCard
            }
        }
    }
}
