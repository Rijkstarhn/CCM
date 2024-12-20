import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CCMViewModel
    @State var cardName: String = ""
    @State var rewards: [String: Int] = [:]
    @Environment(\.presentationMode) var presentationMode
    
    // Optional parameter for editing
    var existingCard: Card?
    
    var body: some View {
        Form {
            TextField("Card Name", text: $cardName)
            
            ForEach(viewModel.categories) { category in
                HStack {
                    Text(category.name)
                    Spacer()
                    Picker("Reward (%)", selection: Binding(
                        get: { rewards[category.name] ?? 0 },
                        set: { rewards[category.name] = $0 }
                    )) {
                        ForEach(0...10, id: \.self) { value in
                            Text("\(value)%").tag(value)
                        }
                    }
                }
            }
            
            Button(existingCard == nil ? "Add Credit Card" : "Update Credit Card") {
                if let card = existingCard {
                    // Update existing card
                    if let index = viewModel.cards.firstIndex(where: { $0.id == card.id }) {
                        viewModel.cards[index] = Card(
                            name: cardName,
                            rewards: rewards.mapValues { Double($0) }
                        )
                    }
                } else {
                    // Add new card
                    viewModel.addCard(name: cardName, rewards: rewards.mapValues { Double($0) })
                }
                presentationMode.wrappedValue.dismiss() // Navigate back
            }
        }
        .navigationTitle(existingCard == nil ? "Add Credit Card" : "Update Credit Card")
        .onAppear {
            if let card = existingCard {
                cardName = card.name
                rewards = card.rewards.mapValues { Int($0) }
            }
        }
    }
}
