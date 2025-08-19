//
//  WentListView.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//

import SwiftUI

struct WentListView: View {
    @StateObject var viewModel: WentListVM
    
    @State private var selectedFilter: Category? = nil
    @State private var selectedItem: Location?
    
    var body: some View {
        VStack {
            if viewModel.fileteredWentlistLocations.isEmpty {
                Text("Looks like your list is empty. Start reviewing (or at least visiting) the places you've added to your wishlist.")
                    .padding()
                    .font(.system(size: 45, design: .rounded))
                    .fontWeight(.black)
                    .foregroundStyle(Color.app.primaryText)
            } else {
                VStack {
                    FilterView(viewModel: viewModel)
                    
                    HorizontalDottedLine()

                    List(viewModel.fileteredWentlistLocations) { location in
                        WentListCellView(viewModel: viewModel, wentLocation: location)
                            .listRowInsets(.init())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                selectedItem = location
                            }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .navigationDestination(item: $selectedItem, destination: { selectedItem in
                        LocationDetailView(location: selectedItem, screenType: .wentList)
                            .toolbar(.hidden)
                    })
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.app.primaryBackground.ignoresSafeArea()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    var persistanceManager = MockPersistanceManager() as PersistanceManager
    return WentListView(viewModel: WentListVM(persistanceManager: persistanceManager))
        .environmentObject(LocationManager())
        .environmentObject(persistanceManager)
        .modelContainer(for: [Category.self, Location.self], inMemory: true)
}
