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
    
    // Predefined categories that users can choose from
    let predefinedCategories = [
        Category(name: "Gas", icon: "fuelpump.fill"),
        Category(name: "Groceries", icon: "cart.fill"),
        Category(name: "Online Shopping", icon: "bag.fill"),
        Category(name: "Travel", icon: "airplane"),
        Category(name: "Dining", icon: "fork.knife"),
        Category(name: "Entertainment", icon: "tv.fill"),
        Category(name: "Healthcare", icon: "cross.case.fill"),
        Category(name: "Education", icon: "book.fill"),
        Category(name: "Transit", icon: "bus.fill"),
        Category(name: "Utilities", icon: "bolt.fill")
    ]
    
    init() {
        loadData()
    }
    
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
        if let savedCategories = UserDefaults.standard.data(forKey: "savedCategories"),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: savedCategories) {
            categories = decodedCategories
        }
        
        if let savedCards = UserDefaults.standard.data(forKey: "savedCards"),
           let decodedCards = try? JSONDecoder().decode([CreditCard].self, from: savedCards) {
            cards = decodedCards
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
    
    func addCashbackToCard(_ card: CreditCard, category: Category, rate: Double) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            var updatedCard = card
            updatedCard.cashbackRates[category] = rate
            cards[index] = updatedCard
        }
    }
}
