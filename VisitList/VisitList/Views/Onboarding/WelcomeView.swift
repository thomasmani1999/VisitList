//
//  WelcomeView.swift
//  VisitList
//
//  Created by Thomas Mani on 28/06/25.
//

import SwiftUI

struct WelcomeView: View {
    
    //MARK: State variables
    @ObservedObject var viewModel: OnboardingVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
    
                Text("Welcome")
                    .font(.system(size: 20, design: .serif))
                    .foregroundStyle(Color.app.secondaryText)
                Text(viewModel.name)
                    .font(.system(size: 30, design: .rounded))
                    .foregroundStyle(Color.app.primaryText)
                
                Spacer(minLength: 40)
                
                Text("""
                Hey there 👋

                Welcome to my little corner of the App Store. This is a personal hobby project, built with love and curiosity in my spare time.

                If you run into any bugs, or if there’s a feature you wish this app had I’d genuinely love to hear from you.

                Thanks for being here,
                Thomas 🌿
                """)
                    .font(.system(size: 20, design: .serif))
                    .foregroundStyle(Color.app.secondaryText)
                
                Spacer()
                
                HStack(content: {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor( .app.accent )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.isLoggedIn = true
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor( .app.accent )
                    }
                })
                
            }
            .padding(30)
            .navigationBarBackButtonHidden(true)
            .background {
                Color.app.primaryBackground
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    WelcomeView(viewModel: OnboardingVM())
}
