//
//  ShoppingListsStore.swift
//  QuickList
//

import Foundation
import Observation

struct ShoppingListBoard: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var items: [ShoppingItem]
}

@Observable
final class ShoppingListsStore {
    private(set) var boards: [ShoppingListBoard] = []

    private let storageKey = "QuickList.boards.v1"
    private static let legacyItemsKey = "QuickList.shoppingItems"

    init() {
        load()
        migrateLegacyShoppingItems()
    }

    func board(id: UUID) -> ShoppingListBoard? {
        boards.first { $0.id == id }
    }

    @discardableResult
    func createBoard(named rawName: String) -> UUID? {
        let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return nil }
        let id = UUID()
        boards.append(ShoppingListBoard(id: id, name: name, items: []))
        save()
        return id
    }

    func addItem(to listId: UUID, nome: String, quantidade: Int) {
        let trimmed = nome.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let i = boards.firstIndex(where: { $0.id == listId }) else { return }
        let q = max(1, quantidade)
        boards[i].items.append(ShoppingItem(id: UUID(), nome: trimmed, comprado: false, quantidade: q))
        save()
    }

    func toggleItem(listId: UUID, item: ShoppingItem) {
        guard let bi = boards.firstIndex(where: { $0.id == listId }),
              let ii = boards[bi].items.firstIndex(where: { $0.id == item.id })
        else { return }
        boards[bi].items[ii].comprado.toggle()
        save()
    }

    func removeItem(listId: UUID, item: ShoppingItem) {
        guard let bi = boards.firstIndex(where: { $0.id == listId }) else { return }
        boards[bi].items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ShoppingListBoard].self, from: data)
        else {
            boards = []
            return
        }
        boards = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(boards) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func migrateLegacyShoppingItems() {
        guard boards.isEmpty,
              let data = UserDefaults.standard.data(forKey: Self.legacyItemsKey),
              let items = try? JSONDecoder().decode([ShoppingItem].self, from: data),
              !items.isEmpty
        else { return }
        boards = [ShoppingListBoard(id: UUID(), name: "Lista de Compras", items: items)]
        save()
        UserDefaults.standard.removeObject(forKey: Self.legacyItemsKey)
    }
}
