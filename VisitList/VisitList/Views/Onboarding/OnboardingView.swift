//
//  ContentView.swift
//  VisitList
//
//  Created by Thomas Mani on 24/06/25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    
    //MARK: ViewModel
    @StateObject var viewModel: OnboardingVM = OnboardingVM()
    @State private var welcomeUser = false
    
    var body: some View {
        NavigationStack {
            HStack(content: {
                VStack(alignment: .leading) {
                    Text("Hello there")
                        .font(.system(size: 30, design: .serif))
                        .padding(.top, 60)
                        .foregroundStyle(Color.app.primaryText)
                    Text("Welcome to WanderList")
                        .font(.system(size: 20, design: .serif))
                        .foregroundStyle(Color.app.primaryText)
                    Spacer()
                    Text("Who am I talking to ?")
                        .font(.system(size: 20, design: .serif))
                        .foregroundStyle(Color.app.primaryText)
                    TextField("Enter your name", text: viewModel.$name)
                        .font(.system(size: 30, design: .rounded))
                        .foregroundStyle(Color.app.primaryText)
                    Spacer()
                    HStack(content: {
                        Spacer()
                        
                        Button(action: {
                            welcomeUser = true
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.name.isEmpty ? .app.secondaryText : .app.accent )
                        }
                    })
                }
                
                Spacer()
            })
            .padding(30)
            .background {
                ZStack(alignment: .topTrailing, content: {
                    Color.app.primaryBackground
                        .ignoresSafeArea()
                    
                    Image("vine")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 500)
                        .offset(x: 10, y: -75)
                })
            }
            .navigationDestination(isPresented: $welcomeUser) {
                WelcomeView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
