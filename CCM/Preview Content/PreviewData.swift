import Foundation

extension Category {
    static let preview = Category(name: "Gas", icon: "fuelpump.fill")
}

extension CreditCard {
    static let preview = CreditCard(
        name: "Test Card",
        cashbackRates: [Category.preview: 5.0]
    )
}

extension RewardsViewModel {
    static var preview: RewardsViewModel {
        let viewModel = RewardsViewModel()
        // Add any preview data setup here
        return viewModel
    }
}
