//
//  CategoryRowView.swift
//  CCM
//
//  Created by Rexxay on 2024-12-18.
//

// CategoryRowView.swift
import SwiftUI

struct CategoryRowView: View {
    let category: Category
    let bestCard: (CreditCard, Double)?
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
                if let (card, rate) = bestCard {
                    Text("\(card.name) (\(rate, specifier: "%.1f")%)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                } else {
                    Text("No card assigned")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
