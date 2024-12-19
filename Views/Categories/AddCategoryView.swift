// AddCategoryView.swift
import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: RewardsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var icon = "tag.fill"
    
    let icons = ["tag.fill", "cart.fill", "bag.fill", "airplane", "car.fill", "fuelpump.fill", "fork.knife", "tv.fill", "house.fill"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $name)
                
                Picker("Icon", selection: $icon) {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon).tag(icon)
                    }
                }
            }
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let category = Category(name: name, icon: icon)
                        viewModel.addCategory(category)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
