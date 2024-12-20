import SwiftUI

struct ManageCardsView: View {
    @ObservedObject var viewModel: CCMViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all) // Consistent background
            List {
                ForEach(viewModel.cards) { card in
                    HStack {
                        Text(card.name)
                        Spacer()
                        NavigationLink(destination: CardView(viewModel: viewModel, existingCard: card)) {}
                    }
                }
                .onDelete(perform: deleteCard) // Enable swipe-to-delete
            }
            .listStyle(PlainListStyle()) // Consistent styling
        }
        .navigationTitle("Manage Cards")
    }
    
    private func deleteCard(at offsets: IndexSet) {
        viewModel.cards.remove(atOffsets: offsets)
    }
}
