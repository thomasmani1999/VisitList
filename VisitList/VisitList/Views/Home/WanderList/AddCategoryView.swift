//
//  AddCategoryView.swift
//  VisitList
//
//  Created by Thomas Mani on 12/07/25.
//

import SwiftUI
import MCEmojiPicker

struct AddCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: WanderListVM
    @Binding var selectedCategory: Category?
    
    @State var categoryName: String = ""
    @State var categoryIcon: String = "🔍"
    @State var isPresented: Bool = false
    
    private var isMandatoryDataSet: Bool {
        return !(categoryName.isEmpty || categoryIcon.isEmpty)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("What category do you want to add?")
                    .font(.system(size: 20, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.app.primaryText)
                
                HStack {
                    Spacer()
                    
                    Text("Icon: ")
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.app.primaryText)
                    
                    Button(categoryIcon) {
                        isPresented.toggle()
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }.emojiPicker(
                        isPresented: $isPresented,
                        selectedEmoji: $categoryIcon,
                        arrowDirection: .down
                    )
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(
                        Circle()
                            .fill(Color(.systemGray5))
                            .scaleEffect(isPresented ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isPresented)
                    )
                    .padding(.trailing, 10)
                    
                    Spacer()
                    
                    Text("Name: ")
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.app.primaryText)
                    
                    TextField("Ex: Beach", text: $categoryName)
                        .underline()
                }
                
                Button(action: {
                    addNewCategory()
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
            }
            .ignoresSafeArea()
            .padding(10)
            .padding(.vertical,10)
            .padding(.bottom,20)
            .background(content: {
                Color.app.primaryBackground
                    .ignoresSafeArea()
            })
            .clipShape(RoundedCorners(radius: 20, corners: [.topLeft,.topRight]))
            .padding(.horizontal, 20)
        }
    }
    
    private func addNewCategory() {
        selectedCategory = viewModel.addCategory(name: categoryName, icon: categoryIcon)
    }
}

#Preview {
    var persistance = MockPersistanceManager() as PersistanceManager
    var vm = WanderListVM(persistanceManager: persistance)
    AddCategoryView(viewModel: vm, selectedCategory: .constant(nil))
}
