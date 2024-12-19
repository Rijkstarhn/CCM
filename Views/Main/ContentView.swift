//
//  ContentView.swift
//  CCM
//
//  Created by Rexxay on 2024-12-18.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RewardsViewModel()
    @State private var showingAddCard = false
    @State private var showingAddCategory = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.categories.isEmpty {
                    Section {
                        Text("Add categories to start tracking your rewards!")
                            .foregroundColor(.gray)
                    }
                } else {
                    ForEach(viewModel.categories) { category in
                        CategoryRowView(category: category, bestCard: viewModel.getBestCard(for: category))
                    }
                    .onDelete(perform: viewModel.deleteCategory)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("Cards") {
                        CardListView(viewModel: viewModel)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCategory.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView(viewModel: viewModel)
            }
        }
    }
}
