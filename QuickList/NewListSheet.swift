//
//  NewListSheet.swift
//  QuickList
//

import SwiftUI

struct NewListSheet: View {
    @Environment(\.dismiss) private var dismiss
    var onCreate: (String) -> Void

    @State private var listName = ""
    @FocusState private var nameFocused: Bool

    private var trimmed: String {
        listName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canCreate: Bool {
        !trimmed.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Digite um nome para sua nova lista")
                    .font(.subheadline)
                    .foregroundStyle(QuickListTheme.primaryText.opacity(0.85))

                TextField("Ex.: Lista Frutaria", text: $listName)
                    .focused($nameFocused)
                    .submitLabel(.done)
                    .onSubmit(createIfPossible)
                    .modifier(PinkTextFieldStyle())

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(QuickListTheme.background)
            .navigationTitle("Nova lista")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(QuickListTheme.background, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Criar") { createIfPossible() }
                        .fontWeight(.semibold)
                        .disabled(!canCreate)
                }
            }
            .onAppear { nameFocused = true }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private func createIfPossible() {
        guard canCreate else { return }
        onCreate(trimmed)
        dismiss()
    }
}

#Preview {
    NewListSheet { _ in }
}
