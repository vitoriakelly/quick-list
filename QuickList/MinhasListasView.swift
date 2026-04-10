//
//  MinhasListasView.swift
//  QuickList
//

import SwiftUI

struct MinhasListasView: View {
    @Bindable var store: ShoppingListsStore
    @State private var path = NavigationPath()
    @State private var showNewList = false

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if store.boards.isEmpty {
                    emptyState
                } else {
                    listOfBoards
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(QuickListTheme.background.ignoresSafeArea())
            .navigationTitle("Minhas Listas")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(QuickListTheme.background, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .navigationDestination(for: UUID.self) { listId in
                ListDetailView(listId: listId, store: store)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                newListButton
            }
            .sheet(isPresented: $showNewList) {
                NewListSheet { name in
                    if let id = store.createBoard(named: name) {
                        path.append(id)
                    }
                }
            }
        }
    }

    private var listOfBoards: some View {
        List {
            ForEach(store.boards) { board in
                NavigationLink(value: board.id) {
                    HStack(spacing: 12) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .foregroundStyle(QuickListTheme.accent)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(board.name)
                                .foregroundStyle(QuickListTheme.primaryText)
                                .font(.body.weight(.medium))
                            Text("\(board.items.count) \(board.items.count == 1 ? "item" : "itens")")
                                .font(.caption)
                                .foregroundStyle(QuickListTheme.primaryText.opacity(0.55))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(QuickListTheme.card)
                .listRowSeparatorTint(QuickListTheme.divider)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundStyle(QuickListTheme.accent.opacity(0.65))
            Text("Ainda não tens listas")
                .font(.title3.weight(.semibold))
                .foregroundStyle(QuickListTheme.primaryText)
            Text("Cria uma com o botão em baixo para começar.")
                .font(.subheadline)
                .foregroundStyle(QuickListTheme.primaryText.opacity(0.65))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var newListButton: some View {
        Button {
            showNewList = true
        } label: {
            Label("Nova Lista", systemImage: "plus.circle.fill")
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(QuickListTheme.accent)
        .foregroundStyle(.white)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(QuickListTheme.background.opacity(0.98))
    }
}

#Preview {
    MinhasListasView(store: ShoppingListsStore())
}
