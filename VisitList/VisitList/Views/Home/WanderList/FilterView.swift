//
//  FilterView.swift
//  VisitList
//
//  Created by Thomas Mani on 29/06/25.
//

import SwiftUI

struct FilterView: View {
    
    @ObservedObject var viewModel: WanderListVM
    @Binding var selectedFilter: Category?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6, content: {
                ForEach( viewModel.getPresentCategories() ) { category in
                    Text("\(category.icon) \(category.name)")
                        .font(.system(size: 15, design: .rounded))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 6)
                        .background(selectedFilter == category ? Color.app.accent : Color.app.secondaryText.opacity(0.5))
                        .clipShape(Capsule())
                        .onTapGesture {
                            selectedFilter = category
                        }
                    
                }
            })
            .padding(.horizontal,4)
        }
    }
}

#Preview {
    FilterView(viewModel: WanderListVM(), selectedFilter: .constant(nil))
}
