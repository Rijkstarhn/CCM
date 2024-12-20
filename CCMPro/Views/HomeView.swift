import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = CCMViewModel()
    @State private var selectedTab: String = "HomePage" // Default to HomePage

    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Ensure no gaps
                // Content Based on Selected Tab
                ZStack {
                    Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all) // Consistent background
                    
                    if selectedTab == "HomePage" {
                        homePageContent
                    } else if selectedTab == "Card" {
                        ManageCardsView(viewModel: viewModel)
                    } else if selectedTab == "Category" {
                        ManageCategoriesView(viewModel: viewModel)
                    }
                }

                // Divider and Footer
                Divider() // Separation line
                HStack {
                    Spacer()
                    footerIcon(icon: "house", label: "HomePage", isActive: selectedTab == "HomePage") {
                        selectedTab = "HomePage"
                    }
                    Spacer()
                    footerIcon(icon: "creditcard", label: "Card", isActive: selectedTab == "Card") {
                        selectedTab = "Card"
                    }
                    Spacer()
                    footerIcon(icon: "folder", label: "Category", isActive: selectedTab == "Category") {
                        selectedTab = "Category"
                    }
                    Spacer()
                    footerIcon(icon: "ellipsis.circle", label: "More", isActive: false) {
                        // Placeholder action
                    }
                    Spacer()
                }
                .frame(height: 70)
                .background(Color(UIColor.systemGray6)) // Matches content background
            }
            .toolbar {
                if selectedTab == "HomePage" {
                    // Add Card Button
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink("Add Card") {
                            CardView(viewModel: viewModel)
                        }
                    }
                    
                    // Add Category Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Add Category") {
                            CategoryView(viewModel: viewModel)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    // Home Page Content
    private var homePageContent: some View {
        List {
            ForEach(viewModel.categories) { category in
                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.headline)
                    if let bestCard = category.bestCard, let cashback = bestCard.rewards[category.name] {
                        Text("\(bestCard.name) - \(Int(cashback))% Cashback")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    } else {
                        Text("No Card Available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            viewModel.updateBestCards()
        }
    }

    // Footer Icon Component
    private func footerIcon(icon: String, label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        VStack {
            Button(action: action) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(isActive ? .blue : .gray)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(isActive ? .blue : .gray)
        }
    }
}
