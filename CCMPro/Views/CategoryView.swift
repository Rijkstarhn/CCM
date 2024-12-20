import SwiftUI

struct CategoryView: View {
    @ObservedObject var viewModel: CCMViewModel
    @State var categoryName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    // Optional parameter for editing
    var existingCategory: Category?
    
    var body: some View {
        Form {
            TextField("Category Name", text: $categoryName)
            
            Button(existingCategory == nil ? "Add Category" : "Update Category") {
                if let category = existingCategory {
                    // Update existing category
                    if let index = viewModel.categories.firstIndex(where: { $0.id == category.id }) {
                        viewModel.categories[index] = Category(name: categoryName, bestCard: category.bestCard)
                    }
                } else {
                    // Add new category
                    viewModel.addCategory(name: categoryName)
                }
                presentationMode.wrappedValue.dismiss() // Navigate back
            }
        }
        .navigationTitle(existingCategory == nil ? "Add Category" : "Update Category")
        .onAppear {
            if let category = existingCategory {
                categoryName = category.name
            }
        }
    }
}
