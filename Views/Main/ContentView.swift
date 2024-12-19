//
//  ContentView.swift
//  CCM
//
//  Created by Rexxay on 2024-12-18.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RewardsViewModel()
    @State private var showingAddCard = false
    @State private var showingAddCategory = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories) { category in
                    CategoryRowView(category: category, bestCard: viewModel.getBestCard(for: category))
                }
                .onDelete(perform: viewModel.deleteCategory)
            }
            .navigationTitle("CCM")
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
