//
//  HomeView.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var persistence: PersistanceManager
    
    @StateObject private var viewModel: HomeVM = HomeVM()
    
    var body: some View {
        VStack(content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Hey")
                        .font(.system(size: 20, design: .rounded))
                        .foregroundStyle(Color.app.primaryText)
                    
                    Text(viewModel.getUsername())
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.app.primaryText)
                    
                    Spacer()
                    
                }
                
                Text("Where do you wanna go today?")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(Color.app.primaryText)
            }
            .padding(.horizontal)
            
            TabView(selection: $viewModel.selectedTab) {
                LocationView(viewModel: LocationViewVM(persistanceManager: persistence))
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                
                WanderListView(viewModel: WanderListVM(persistanceManager: persistence))
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
                
                WentListView(viewModel: WentListVM(persistanceManager: persistence))
                    .tag(2)
                    .toolbar(.hidden, for: .tabBar)
            }
            
            HStack {
                ForEach(TabbedItems.allCases, id: \.self) { item in
                    Button {
                        viewModel.selectedTab = item.rawValue
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    } label: {
                        customTabItem(tabItem: item, isActive: viewModel.selectedTab == item.rawValue)
                    }
                    
                }
            }
            .padding(6)
            .frame(height: 70)
            .background(Color.app.accent.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.horizontal,20)
            .padding(.bottom, 5)
        })
        .background {
            Color.app.primaryBackground
                .ignoresSafeArea()
        }
        .onAppear {
            persistence.setContext(context)
        }
    }
    
    func customTabItem(tabItem: TabbedItems, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            
            Image(systemName: tabItem.iconName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? Color.app.primaryText : Color.app.secondaryText)
                .frame(width: 20, height: 20)
            
            if isActive {
                Text(tabItem.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(isActive ? Color.app.primaryText : Color.app.secondaryText)
            }
            
            Spacer()
        }
        .frame(maxWidth: isActive ? .infinity : 60, maxHeight: 60)
        .background(isActive ? Color.app.accent.opacity(0.4) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

#Preview {
    
    return HomeView()
        .environmentObject(PersistanceManager())
        .modelContainer(for: [Category.self, Location.self], inMemory: true)
}
