// CardListView.swift
import SwiftUI

struct CardListView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @State private var showingAddCard = false
    
    var body: some View {
        List {
            ForEach(viewModel.cards) { card in
                VStack(alignment: .leading) {
                    Text(card.name)
                        .font(.headline)
                    ForEach(Array(card.cashbackRates.keys), id: \.self) { category in
                        if let rate = card.cashbackRates[category] {
                            Text("\(category.name): \(rate, specifier: "%.1f")%")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
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
    }
}

// AddCardView.swift
import SwiftUI

struct AddCardView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var selectedRates: [Category: Double] = [:]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Card Name", text: $name)
                
                Section("Cashback Rates") {
                    ForEach(viewModel.categories) { category in
                        HStack {
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
            .navigationTitle("New Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let card = CreditCard(name: name, cashbackRates: selectedRates)
                        viewModel.addCard(card)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
