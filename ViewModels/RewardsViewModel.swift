import Foundation

class RewardsViewModel: ObservableObject {
    @Published var cards: [CreditCard] = [] {
        didSet {
            saveCards()
        }
    }
    
    @Published var categories: [Category] = [] {
        didSet {
            saveCategories()
        }
    }
    
    init() {
        loadData()
    }
    
    // MARK: - Persistence Methods
    private func saveCards() {
        if let encoded = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(encoded, forKey: "savedCards")
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "savedCategories")
        }
    }
    
    private func loadData() {
        // Load categories
        if let savedCategories = UserDefaults.standard.data(forKey: "savedCategories"),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: savedCategories) {
            categories = decodedCategories
        } else {
            // Load default categories if no saved data exists
            categories = [
                Category(name: "Gas", icon: "fuelpump.fill"),
                Category(name: "Groceries", icon: "cart.fill"),
                Category(name: "Online Shopping", icon: "bag.fill"),
                Category(name: "Travel", icon: "airplane"),
                Category(name: "Dining", icon: "fork.knife"),
                Category(name: "Entertainment", icon: "tv.fill")
            ]
        }
        
        // Load cards
        if let savedCards = UserDefaults.standard.data(forKey: "savedCards"),
           let decodedCards = try? JSONDecoder().decode([CreditCard].self, from: savedCards) {
            cards = decodedCards
        } else {
            // Load default cards if no saved data exists
            cards = [
                CreditCard(name: "Freedom Unlimited", cashbackRates: [
                    categories[0]: 1.5,  // Gas
                    categories[1]: 1.5,  // Groceries
                    categories[2]: 3.0   // Online Shopping
                ]),
                CreditCard(name: "Sapphire Preferred", cashbackRates: [
                    categories[3]: 5.0,  // Travel
                    categories[4]: 3.0   // Dining
                ]),
                CreditCard(name: "Cash Plus", cashbackRates: [
                    categories[1]: 6.0,  // Groceries
                    categories[5]: 4.0   // Entertainment
                ])
            ]
        }
    }
    
    func getBestCard(for category: Category) -> (CreditCard, Double)? {
        let cardsWithRate = cards.compactMap { card -> (CreditCard, Double)? in
            guard let rate = card.cashbackRates[category] else { return nil }
            return (card, rate)
        }
        return cardsWithRate.max(by: { $0.1 < $1.1 })
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
    }
    
    func deleteCategory(at indexSet: IndexSet) {
        // Remove the category from all cards' cashback rates before deleting
        let categoriesToDelete = indexSet.map { categories[$0] }
        for categoryToDelete in categoriesToDelete {
            for index in cards.indices {
                cards[index].cashbackRates.removeValue(forKey: categoryToDelete)
            }
        }
        categories.remove(atOffsets: indexSet)
    }
    
    func addCard(_ card: CreditCard) {
        cards.append(card)
    }
    
    func deleteCard(at indexSet: IndexSet) {
        cards.remove(atOffsets: indexSet)
    }
}
