import SwiftUI

struct ManageCategoriesView: View {
    @ObservedObject var viewModel: CCMViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all) // Consistent background
            List {
                ForEach(viewModel.categories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        NavigationLink(destination: CategoryView(viewModel: viewModel, existingCategory: category)) {}
                    }
                }
                .onDelete(perform: deleteCategory) // Enable swipe-to-delete
            }
            .listStyle(PlainListStyle()) // Consistent styling
        }
        .navigationTitle("Manage Categories")
    }
    
    private func deleteCategory(at offsets: IndexSet) {
        viewModel.categories.remove(atOffsets: offsets)
    }
}
