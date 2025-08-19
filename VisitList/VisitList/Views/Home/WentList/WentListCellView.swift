//
//  WentListCellView.swift
//  VisitList
//
//  Created by Thomas Mani on 31/07/25.
//

import SwiftUI
import SwiftData

struct WentListCellView: View {
    
    @ObservedObject var viewModel: WentListVM
    @State private var showDeleteAlert = false
    
    var wentLocation: Location
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack (alignment: .leading, spacing: 3) {
                    Text(wentLocation.category.icon + " " +  wentLocation.title)
                        .font(.system(size: 25, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.app.primaryText)
                    
                    StarRatingView(rating: .constant(wentLocation.rating ?? 0), isInteractive: false, starSize: 15)
                        .disabled(true)
                        .padding(5)
                        .background(Color.app.primaryBackground)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
                .alert("Are you sure you want to delete?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            viewModel.deleteWentlistLocation(wentLocation)
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            .padding(.bottom,15)
            
            HorizontalDottedLine()
                .offset(y: -10)
            
            HStack(content: {
                VStack(alignment: .leading, content: {
                    HStack(alignment: .top) {
                        Text("📍")
                            .font(.system(size: 10, design: .rounded))
                        Text(wentLocation.address ?? "")
                            .font(.system(size: 13, design: .rounded))
                            .offset(x: -5)
                    }
                    .padding(.bottom, 5)
                    
                    if let thingsTodo = wentLocation.thingsToDo, !thingsTodo.isEmpty {
                        Text("Must try stuff:-")
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.app.primaryText)
                            .padding(.bottom, 1)
                        
                        Text(thingsTodo)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundStyle(Color.app.primaryText)
                            .padding(.bottom, 5)
                    }
                })
                
                Spacer()
                
                HStack(content: {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.app.accent)
                })
            })
        }
        .padding(10)
        .background(Color.app.highlight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background {
            Color.app.primaryBackground.ignoresSafeArea()
        }
    }
        
    
}

#Preview {
    var persistence = MockPersistanceManager() as PersistanceManager
    var originalVM = WentListVM(persistanceManager: persistence)
    var vm = WanderListVM(persistanceManager: persistence)
    var cat = vm.addCategory(name: "Cafe", icon: "☕️")
    var location = vm.addWishlistedLocation(title: "Paulettans Pizzeria", category: cat, coordinates: Coordinate(latitude: 0, longitude: 0), thingsToDo: nil, socialMediaContent: nil, address: "")
    
    location.setLocation(location: Coordinate(latitude: 10.516687, longitude: 76.225437))
    location.setThingsToDo("Try out their amazing pizzas")
    location.setSocialMediaContent("https://www.google.com")
    location.setRating(4.2)
    return WentListCellView(viewModel: originalVM, wentLocation: location)
}
