import SwiftUI

struct AddCardView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var selectedRates: [Category: Double] = [:]
    @State private var showingAddCategory = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Card Name", text: $name)
                
                if !viewModel.categories.isEmpty {
                    Section("Cashback Rates") {
                        ForEach(viewModel.categories) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.name)
                                Spacer()
                                TextField("Rate", value: Binding(
                                    get: { selectedRates[category] ?? 0 },
                                    set: { selectedRates[category] = $0 }
                                ), formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                Text("%")
                            }
                        }
                    }
                }
                
                Button("Add New Category") {
                    showingAddCategory.toggle()
                }
            }
            .navigationTitle("New Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newRates = selectedRates.filter { $0.value > 0 }
                        let card = CreditCard(name: name, cashbackRates: newRates)
                        viewModel.addCard(card)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView(viewModel: viewModel)
            }
        }
    }
}

struct CardListView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @State private var showingAddCard = false
    @State private var selectedCard: CreditCard? = nil
    @State private var showingAddCategory = false
    
    var body: some View {
        List {
            ForEach(viewModel.cards) { card in
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.name)
                        .font(.headline)
                    
                    ForEach(Array(card.cashbackRates.keys), id: \.self) { category in
                        if let rate = card.cashbackRates[category] {
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.name)
                                Spacer()
                                Text("\(rate, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            }
                            .font(.subheadline)
                        }
                    }
                    
                    Button("Add Category") {
                        selectedCard = card
                        showingAddCategory.toggle()
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
                .padding(.vertical, 4)
            }
            .onDelete(perform: viewModel.deleteCard)
        }
        .navigationTitle("Credit Cards")
        .toolbar {
            Button(action: { showingAddCard.toggle() }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddCard) {
            AddCardView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddCategory) {
            if let card = selectedCard {
                AddCategoryToCardView(viewModel: viewModel, card: card)
            }
        }
    }
}

struct AddCategoryToCardView: View {
    @ObservedObject var viewModel: RewardsViewModel
    let card: CreditCard
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: Category?
    @State private var cashbackRate: Double = 0
    
    var availableCategories: [Category] {
        viewModel.categories.filter { category in
            !card.cashbackRates.keys.contains(category)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                if availableCategories.isEmpty {
                    Section {
                        Text("No available categories to add")
                            .foregroundColor(.gray)
                    }
                } else {
                    Section("Select Category") {
                        ForEach(availableCategories) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                HStack {
                                    Image(systemName: category.icon)
                                    Text(category.name)
                                    Spacer()
                                    if selectedCategory?.id == category.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    
                    if selectedCategory != nil {
                        Section("Cashback Rate") {
                            HStack {
                                TextField("Rate", value: $cashbackRate, formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                Text("%")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Category to \(card.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let category = selectedCategory {
                            viewModel.addCashbackToCard(card, category: category, rate: cashbackRate)
                        }
                        dismiss()
                    }
                    .disabled(selectedCategory == nil || cashbackRate == 0)
                }
            }
        }
    }
}
