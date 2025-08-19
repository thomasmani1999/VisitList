//
//  FilterView.swift
//  VisitList
//
//  Created by Thomas Mani on 29/06/25.
//

import SwiftUI

struct FilterView<ViewModel: Filterable>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(content: {
                Spacer()
                    .frame(width: 14)
                ForEach( viewModel.getPresentCategories() ) { category in
                    Text("\(category.icon) \(category.name)")
                        .font(.system(size: 15, design: .rounded))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 6)
                        .background(viewModel.selectedFilter == category ? Color.app.accent : Color.app.secondaryText.opacity(0.5))
                        .clipShape(Capsule())
                        .onTapGesture {
                            withAnimation {
                                if viewModel.selectedFilter == category {
                                    viewModel.setFilter(nil)
                                } else {
                                    viewModel.setFilter(category)
                                }
                            }
                        }
                        .padding(.horizontal, 6)
                    
                }
            })
            .padding(.horizontal,4)
        }
    }
}

#Preview {
    var persistance = MockPersistanceManager() as PersistanceManager
    var viewModel: WanderListVM = WanderListVM(persistanceManager: persistance)
    FilterView(viewModel: viewModel)
}
