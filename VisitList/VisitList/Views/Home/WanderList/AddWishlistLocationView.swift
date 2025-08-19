//
//  AddWishlistLocationView.swift
//  VisitList
//
//  Created by Thomas Mani on 02/07/25.
//

import SwiftUI
import SwiftData
import MapKit

struct AddWishlistLocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WanderListVM
    
    @State var locationTitle: String = ""
    @State var thingsToDo: String = ""
    @State var selectedCategory: Category?
    @State var showAddCategory: Bool = false
    @State var shortLink: String = ""
    @State var coordinates: Coordinate?
    @State var address: String = ""
    @State var showLocPickerView = false
    
    private var selectedTitleText: String
    private var selectedToText: String
    private var selectedNameText: String
    private var selectedCategoryText: String
    private var selectedShortVideoLink: String
    private var isMandatoryDataSet: Bool {
        return !(locationTitle.isEmpty || selectedCategory == nil || coordinates == nil)
    }
    
    init(viewModel: WanderListVM) {
        
        self.viewModel = viewModel
        
        selectedTitleText = Strings.titleTexts.randomElement() ?? ""
        selectedToText = Strings.todoTexts.randomElement() ?? ""
        selectedNameText = Strings.nameTexts.randomElement() ?? ""
        selectedCategoryText = Strings.categoryPromptTexts.randomElement() ?? ""
        selectedShortVideoLink = "📎 Paste Link :"
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text(selectedTitleText)
                    .font(.system(size: 25, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.app.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                    .padding(.top,10)
                
                HorizontalDottedLine()
                    .padding(.bottom,20)
                
                VStack(alignment: .leading, content: {
                    Text(selectedNameText)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                    
                    TextField("Jurassic Park", text: $locationTitle)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                        .padding(.bottom, 20)
                    
                    Text(selectedToText)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                    ZStack(alignment: .leading) {
                        if thingsToDo.isEmpty {
                            Text("""
    1. Outrun a T. rex in a Jeep while yelling “Must go faster!”
    2. Stand completely still and pray the T. rex doesn’t see you.
    3. Eat melting ice cream during a full-on dinosaur outbreak.
    """)
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.app.secondaryText)
                        }
                        
                        TextEditor(text: $thingsToDo)
                            .scrollContentBackground(.hidden)
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.app.primaryText)
                    }
                    .frame(height: 150)
                    .padding(.bottom, 20)
                    
                    Text(selectedCategoryText)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.app.primaryText)
                    
                    CategoryMenuPill(viewModel: viewModel, selectedCat: $selectedCategory, showAddCategory: $showAddCategory)
                    
                    HStack {
                        Text(selectedShortVideoLink)
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.app.primaryText)
                        
                        TextField("TikTok / Reels / Shorts link…", text: $shortLink)
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.app.primaryText)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        showLocPickerView = true
                    }) {
                        HStack(content: {
                            Text(address.isEmpty ? "Pin the location 📍" : "📍 " + address)
                                .font(.system(size: 15, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(Color.app.primaryText)
                            
                            Spacer()
                            
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
                        .padding(18)
                        .background(Color.app.highlight)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        creatwWishlistLoc()
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(isMandatoryDataSet ? Color.app.accent : Color.app.secondaryText)
                            .foregroundColor(Color.white)
                            .cornerRadius(25)
                    }
                    .disabled(!isMandatoryDataSet)
                    
                })
                .padding(.horizontal, 20)
            }
            .sheet(isPresented: $showLocPickerView) {
                LocationPickerView(userSelectedCoords: $coordinates, address: $address )
            }
            
            if showAddCategory {
                Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .blur(radius: 10)
            }
        
        }
        .background {
            Color.app.primaryBackground.ignoresSafeArea()
        }
    }
    
    private func creatwWishlistLoc() {
        guard let selectedCategory, let coordinates else { return }
        viewModel.addWishlistedLocation(title: locationTitle, category: selectedCategory, coordinates: coordinates, thingsToDo: thingsToDo, socialMediaContent: shortLink, address: address)
    }
}

#Preview {
    var locationManager = LocationManager()
    var perstManager = MockPersistanceManager() as PersistanceManager
    var vm = WanderListVM(persistanceManager: perstManager)
    vm.addCategory(name: "Test", icon: "⛲️")
    return AddWishlistLocationView(viewModel: vm)
        .environmentObject(locationManager)
}
