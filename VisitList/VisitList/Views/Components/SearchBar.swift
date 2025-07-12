//
//  SearchBar.swift
//  VisitList
//
//  Created by Thomas Mani on 10/07/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var placeholder: String = "Search"
    var onCancel: (() -> Void)?

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField(placeholder, text: $text)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .onChange(of: text) { oldValue, newValue in
                        withAnimation {
                            if newValue.isEmpty {
                                isEditing = false
                            } else {
                                isEditing = true
                            }
                        }
                    }

                // Clear button (only when there's text)
                if isEditing {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                // Border when active
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEditing ? Color.app.accent : Color.clear, lineWidth: 1)
            )

            // Cancel button
            if isEditing {
                Button("Cancel") {
                    withAnimation {
                        text = ""
                        isEditing = false
                        if let onCancel {
                            onCancel()
                        }
                        // Dismiss keyboard
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil, from: nil, for: nil
                        )
                    }
                }
                .font(.system(size: 15, design: .rounded))
                .padding(8)
                .background(Color.app.accent)
                .foregroundStyle(Color.app.primaryBackground)
                .clipShape(Capsule())
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}
#Preview {
    @Previewable @State var text: String = "test"
    return SearchBar(text: $text)
}
