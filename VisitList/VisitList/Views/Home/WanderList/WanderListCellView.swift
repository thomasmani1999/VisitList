//
//  WanderListCellView.swift
//  VisitList
//
//  Created by Thomas Mani on 30/06/25.
//

import SwiftUI
import SwiftData

struct WanderListCellView: View {
    
    @EnvironmentObject private var persistence: PersistanceManager
    
    @State private var showDeleteAlert = false
    
    var wishlistedLocation: WishlistLocation
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(wishlistedLocation.category.icon + " " +  wishlistedLocation.title)
                    .font(.system(size: 25, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.app.primaryText)
                
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
                            persistence.deleteWishlistedLocation(wishlistedLocation)
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            
            HorizontalDottedLine()
                .offset(y: -10)
            
            HStack(content: {
                VStack(alignment: .leading, content: {
                    HStack(alignment: .top) {
                        Text("📍")
                            .font(.system(size: 10, design: .rounded))
                        Text(wishlistedLocation.address ?? "")
                            .font(.system(size: 13, design: .rounded))
                            .offset(x: -5)
                    }
                    .padding(.bottom, 5)
                    
                    if let thingsTodo = wishlistedLocation.thingsToDo, !thingsTodo.isEmpty {
                        Text("Things to do :-")
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.app.primaryText)
                            .padding(.bottom, 1)
                        
                        Text(thingsTodo)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundStyle(Color.app.primaryText)
                            .padding(.bottom, 5)
                    }
                    
                    if let socialMediaContent = wishlistedLocation.socialMediaContent, let contentUrl = URL(string: socialMediaContent) {
                        HStack(content: {
                            Text("🔗")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundStyle(Color.app.primaryText)
                            
                            Link("Click here", destination: contentUrl)
                                .font(.system(size: 15, design: .rounded))
                        })
                    }
                })
                
                Spacer()
                
                HStack(content: {
                    Image(systemName: "map.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color.app.accent)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
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
    var cat = persistence.addCategory(name: "Cafe", icon: "☕️")
    var location = persistence.addWishlistedLocation(title: "Paulettans Pizzeria", category: cat, coordinates: Coordinate(latitude: 0, longitude: 0), thingsToDo: nil, socialMediaContent: nil, address: "")
    
    location.setLocation(location: Coordinate(latitude: 10.516687, longitude: 76.225437))
    location.setThingsToDo("Try out their amazing pizzas")
    location.setSocialMediaContent("https://www.google.com")
    return WanderListCellView(wishlistedLocation: location)
}
