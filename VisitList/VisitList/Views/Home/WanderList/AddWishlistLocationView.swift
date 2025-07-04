//
//  AddWishlistLocationView.swift
//  VisitList
//
//  Created by Thomas Mani on 02/07/25.
//

import SwiftUI
import SwiftData

struct AddWishlistLocationView: View {
    
    @ObservedObject var viewModel: WanderListVM
    
    @State var locationTitle: String = ""
    @State var thingsToDo: String = ""
    @State var selectedCategory: Category?
    @State var showAddSheet: Bool = false
    
    private var selectedTitleText: String
    private var selectedToText: String
    private var selectedNameText: String
    private var selectedCategoryText: String
    private var selectedCategoryPromptOption: String
    //    @Attribute(.unique) var id: UUID = UUID.init()
    //    var title: String
    //    @Relationship(deleteRule: .nullify) var category: Category
    //    var thingsToDo: String?
    //    var lattitude: Double?
    //    var longitude: Double?
    //    var createdAt: Date
    //    var socialMediaContent: String?
    
    init(viewModel: WanderListVM) {
        self.viewModel = viewModel
        
        selectedTitleText = titleTexts.randomElement() ?? ""
        selectedToText = todoTexts.randomElement() ?? ""
        selectedNameText = nameTexts.randomElement() ?? ""
        selectedCategoryText = categoryPromptTexts.randomElement() ?? ""
        selectedCategoryPromptOption = categoryPromptOptions.randomElement() ?? ""
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(selectedTitleText)
                .font(.system(size: 25, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(Color.app.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5)
            
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
                
                Text(selectedCategoryText)
                    .font(.system(size: 20, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.app.primaryText)
                
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
                        showAddSheet = true
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
                .sheet(isPresented: $showAddSheet) {
                    //TODO: Add custom category creation
                }
                
                
            })
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background {
            Color.app.primaryBackground.ignoresSafeArea()
        }
    }
    
    // String contents
    var titleTexts = [
        "Where’s your next adventure?",
        "Add a spot you’re dreaming about",
        "Pin a place for future you",
        "Plot a point on your personal map",
        "Somewhere on your mind? \n Drop it here.",
        "Wish you were there? \n Add it here.",
        "Toss in a place you’re dying to go"]
    
    var nameTexts = [
        "What’s this spot called?",
        "Got a name for this place?",
        "Name that café, shop, or secret lair!",
        "What do we call this legendary location?",
        "Place name, store name, hangout name — drop it here!",
        "Give it a name before it becomes that place you forgot",
    ]
    
    var todoTexts = [
        "What’s on your to-do list here?",
        "Got plans for this spot?",
        "What are you hoping to do (or eat) here?",
        "What’s the main mission at this place?",
        "Do, see, try, buy — what’s the plan?"]
    
    var categoryPromptTexts = [
        "How would you label this place?",
        "Pick a vibe!",
        "What kind of spot is this?",
        "Tag this destination",
        "What's the flavor of this place?",
        "Choose your category of awesome",
        "Classify this cool spot",
        "What’s the genre here?",
        "This place feels like a..."
    ]
    
    var categoryPromptOptions = [
        "Pick a vibe",
        "Label this spot",
        "Choose a type",
        "What kind of place?",
        "Tag it!",
        "What's the vibe?",
        "Place type?"
    ]
}

#Preview {
    let schema = Schema([Category.self, WishlistLocation.self])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])
    let context = container.mainContext
    var vm = WanderListVM()
    vm.setContext(context)
    return AddWishlistLocationView(viewModel: vm)
        .modelContainer(container)
}
