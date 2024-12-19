import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var icon = "tag.fill"
    @State private var isCustomCategory = false
    @State private var selectedPredefinedCategory: Category?
    
    let icons = ["tag.fill", "cart.fill", "bag.fill", "airplane", "car.fill", "fuelpump.fill",
                 "fork.knife", "tv.fill", "house.fill", "cross.case.fill", "book.fill", "bus.fill", "bolt.fill"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Category Type", selection: $isCustomCategory) {
                        Text("Choose Existing").tag(false)
                        Text("Create New").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                
                if isCustomCategory {
                    Section("New Category Details") {
                        TextField("Category Name", text: $name)
                        
                        Picker("Icon", selection: $icon) {
                            ForEach(icons, id: \.self) { icon in
                                Label("", systemImage: icon).tag(icon)
                            }
                        }
                    }
                } else {
                    Section("Choose Category") {
                        ForEach(viewModel.predefinedCategories) { category in
                            if !viewModel.categories.contains(where: { $0.name == category.name }) {
                                Button(action: {
                                    selectedPredefinedCategory = category
                                }) {
                                    HStack {
                                        Image(systemName: category.icon)
                                        Text(category.name)
                                        Spacer()
                                        if selectedPredefinedCategory?.id == category.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if isCustomCategory {
                            let category = Category(name: name, icon: icon)
                            viewModel.addCategory(category)
                        } else if let selected = selectedPredefinedCategory {
                            viewModel.addCategory(selected)
                        }
                        dismiss()
                    }
                    .disabled(isCustomCategory ? name.isEmpty : selectedPredefinedCategory == nil)
                }
            }
        }
    }
}
