//
//  ShoppingItem.swift
//  QuickList
//

import Foundation

struct ShoppingItem: Codable, Identifiable, Equatable {
    let id: UUID
    var nome: String
    var comprado: Bool
    var quantidade: Int

    init(id: UUID, nome: String, comprado: Bool, quantidade: Int = 1) {
        self.id = id
        self.nome = nome
        self.comprado = comprado
        self.quantidade = quantidade
    }

    enum CodingKeys: String, CodingKey {
        case id, nome, comprado, quantidade
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        nome = try c.decode(String.self, forKey: .nome)
        comprado = try c.decode(Bool.self, forKey: .comprado)
        quantidade = try c.decodeIfPresent(Int.self, forKey: .quantidade) ?? 1
    }
}
