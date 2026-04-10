//
//  ListDetailView.swift
//  QuickList
//

import SwiftUI

struct ListDetailView: View {
    let listId: UUID
    @Bindable var store: ShoppingListsStore

    @State private var newItemName = ""
    @State private var newItemQuantity = "1"
    @State private var sharePayload: SharePayload?
    @FocusState private var focusedField: Field?

    private enum Field {
        case nome, quantidade
    }

    private var board: ShoppingListBoard? {
        store.board(id: listId)
    }

    private var items: [ShoppingItem] {
        board?.items ?? []
    }

    private var navigationTitle: String {
        board?.name ?? "Lista"
    }

    private var trimmedInput: String {
        newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var parsedQuantity: Int {
        let t = newItemQuantity.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let n = Int(t), n > 0 else { return 1 }
        return n
    }

    private var canAdd: Bool {
        !trimmedInput.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack(alignment: .center, spacing: 10) {
                    TextField("Nome do item", text: $newItemName)
                        .focused($focusedField, equals: .nome)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .quantidade }
                        .modifier(PinkTextFieldStyle())

                    TextField("Qtd", text: $newItemQuantity)
                        .keyboardType(.numberPad)
                        .frame(width: 52)
                        .multilineTextAlignment(.center)
                        .focused($focusedField, equals: .quantidade)
                        .modifier(PinkTextFieldStyle())

                    Button(action: addItem) {
                        Text("Adicionar")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(canAdd ? Color.white : QuickListTheme.accentDeep)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(minHeight: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(canAdd ? QuickListTheme.accent : QuickListTheme.border)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)

            List {
                ForEach(items) { item in
                    HStack(alignment: .center, spacing: 12) {
                        Text(ItemEmojiResolver.emoji(for: item.nome))
                            .font(.title2)
                            .frame(width: 36, alignment: .center)
                            .opacity(item.comprado ? 0.5 : 1)

                        Text(item.nome)
                            .foregroundStyle(QuickListTheme.primaryText)
                            .strikethrough(item.comprado, color: QuickListTheme.primaryText.opacity(0.6))
                        Spacer(minLength: 8)
                        Text("\(item.quantidade)")
                            .foregroundStyle(QuickListTheme.primaryText)
                            .fontWeight(.medium)
                            .monospacedDigit()
                            .opacity(item.comprado ? 0.45 : 1)
                    }
                    .opacity(item.comprado ? 0.55 : 1)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.toggleItem(listId: listId, item: item)
                    }
                    .listRowBackground(QuickListTheme.card)
                    .listRowSeparatorTint(QuickListTheme.divider)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.removeItem(listId: listId, item: item)
                        } label: {
                            Label("Apagar", systemImage: "trash")
                        }
                        .tint(QuickListTheme.accentDeep)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            Rectangle()
                .fill(QuickListTheme.divider)
                .frame(height: 1)

            Button {
                prepareShare()
            } label: {
                Label("Partilhar PDF", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(QuickListTheme.accent)
            .foregroundStyle(.white)
            .padding(.horizontal)
            .padding(.vertical, 14)
            .background(QuickListTheme.background)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(QuickListTheme.background.ignoresSafeArea())
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(QuickListTheme.background, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .sheet(item: $sharePayload) { payload in
            ActivityShareSheet(items: [payload.url])
        }
    }

    private func addItem() {
        guard canAdd else { return }
        store.addItem(to: listId, nome: newItemName, quantidade: parsedQuantity)
        newItemName = ""
        newItemQuantity = "1"
        focusedField = .nome
    }

    private func prepareShare() {
        guard let data = ShoppingListPDFExporter.makePDF(items: items, title: navigationTitle) else { return }
        let base = navigationTitle
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
        let fileName = base.isEmpty ? "Lista.pdf" : "\(base).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: .atomic)
            sharePayload = SharePayload(url: url)
        } catch {}
    }
}

private struct SharePayload: Identifiable {
    let id = UUID()
    let url: URL
}

#Preview {
    NavigationStack {
        ListDetailView(
            listId: UUID(),
            store: ShoppingListsStore()
        )
    }
}
