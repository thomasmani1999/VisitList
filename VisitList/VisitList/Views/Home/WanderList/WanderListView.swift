//
//  WanderListView.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import SwiftUI
import SwiftData

struct WanderListView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject var viewModel: WanderListVM = WanderListVM()
    @State private var selectedFilter: Category? = nil
    @State private var showAddLocVC = false
    @State private var selectedItem: WishlistLocation?
    @State private var isPushing = false
    
    var body: some View {
        VStack {
            if viewModel.wishlistedLocations.isEmpty {
                Text("It seem's your list is empty. Start adding and tracking places you wanna go and thing's you wanna do here")
                    .padding()
                    .font(.system(size: 45, design: .rounded))
                    .fontWeight(.black)
                    .foregroundStyle(Color.app.primaryText)
            } else {
                VStack {
                    FilterView(viewModel: viewModel, selectedFilter: $selectedFilter)
                    
                    HorizontalDottedLine()

                    List(viewModel.wishlistedLocations) { location in
                        WanderListCellView(viewModel: viewModel, wishlistedLocation: location)
                            .listRowInsets(.init())
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)     
                    .listRowSeparator(.hidden)
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
        .onAppear(perform: {
            viewModel.setContext(context)
        })
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
            AddWishlistLocationView(viewModel: viewModel)
        }
    }
}

#Preview {
    WanderListView()
        .environmentObject(LocationManager())
        .modelContainer(for: [Category.self, WishlistLocation.self], inMemory: true)
}
