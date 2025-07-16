//
//  WanderListView.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import SwiftUI
import SwiftData

struct WanderListView: View {
    
    @StateObject var viewModel: WanderListVM
    
    @State private var selectedFilter: Category? = nil
    @State private var showAddLocVC = false
    @State private var selectedItem: WishlistLocation?
    @State private var isPushing = false
    
    var body: some View {
        VStack {
            if viewModel.fileteredWishlistLocations.isEmpty {
                Text("It seem's your list is empty. Start adding and tracking places you wanna go and thing's you wanna do here")
                    .padding()
                    .font(.system(size: 45, design: .rounded))
                    .fontWeight(.black)
                    .foregroundStyle(Color.app.primaryText)
            } else {
                VStack {
                    FilterView(viewModel: viewModel)
                    
                    HorizontalDottedLine()

                    List(viewModel.fileteredWishlistLocations) { location in
                        WanderListCellView(wishlistedLocation: location)
                            .listRowInsets(.init())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .navigationDestination(isPresented: $isPushing) {
                        if let selectedItem {
                            
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.app.primaryBackground.ignoresSafeArea()
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                showAddLocVC = true
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.horizontal ,20)
                    .padding(.bottom ,10)
                    .foregroundStyle(Color.app.accent.opacity(0.6))
            })
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showAddLocVC) {
            AddWishlistLocationView()
        }
    }
}

#Preview {
    var persistanceManager = MockPersistanceManager() as PersistanceManager
    return WanderListView(viewModel: WanderListVM(persistanceManager: persistanceManager))
        .environmentObject(LocationManager())
        .environmentObject(persistanceManager)
        .modelContainer(for: [Category.self, WishlistLocation.self], inMemory: true)
}
