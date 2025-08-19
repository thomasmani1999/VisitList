//
//  CategoryPill.swift
//  VisitList
//
//  Created by Thomas Mani on 26/07/25.
//

import SwiftUI

struct CategoryMenuPill: View {
    
    @ObservedObject var viewModel: WanderListVM
    @Binding var selectedCategory: Category?
    @Binding var showAddCategory: Bool
    
    private var selectedCategoryPromptOption: String
    
    init(viewModel: WanderListVM, selectedCat: Binding<Category?>, showAddCategory: Binding<Bool>) {
        self._selectedCategory = selectedCat
        self._showAddCategory = showAddCategory
        self.viewModel = viewModel
        self.selectedCategoryPromptOption = Strings.categoryPromptOptions.randomElement() ?? ""
    }
    
    var body: some View {
        Menu {
            // Existing categories
            ForEach(viewModel.categories) { cat in
                Button {
                    selectedCategory = cat
                } label: {
                    Text(cat.name + " " + cat.icon)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                }
            }
            
            Divider()
            
            Button {
                showAddCategory = true
            } label: {
                Label("Add Category", systemImage: "plus")
            }
        } label: {
            // Menu label in the main UI
            HStack {
                if let sel = selectedCategory {
                    Text(sel.name + " " + sel.icon)
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                } else {
                    Text(selectedCategoryPromptOption)
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                }
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.app.highlight, in: Capsule())
            .foregroundStyle(Color.app.primaryText)
        }
        .padding(.bottom, 20)
        .sheet(isPresented: $showAddCategory) {
            AddCategoryView(viewModel: viewModel, selectedCategory: $selectedCategory)
                .presentationDetents([.height(180)])
                .presentationDragIndicator(.hidden)
                .presentationBackground(.clear)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    var locationManager = LocationManager()
    var perstManager = MockPersistanceManager() as PersistanceManager
    var vm = WanderListVM(persistanceManager: perstManager)
    var cat = vm.addCategory(name: "Test", icon: "⛲️")
    return  CategoryMenuPill(viewModel: vm, selectedCat: .constant(cat), showAddCategory: .constant(false))
}
