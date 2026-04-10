//
//  ItemEmojiResolver.swift
//  QuickList
//

import Foundation

extension String {
    fileprivate func normalizedForEmojiLookup() -> String {
        folding(options: .diacriticInsensitive, locale: Locale(identifier: "pt_PT"))
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/// Resolve emoji a partir do nome do item: plist PT + palavras-chave + fallback inglês.
enum ItemEmojiResolver {
    private static let plistTable: [String: String] = {
        guard let url = Bundle.main.url(forResource: "ItemEmojiMap", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url) as? [String: String]
        else { return [:] }
        var out: [String: String] = [:]
        for (key, value) in dict {
            let k = key.normalizedForEmojiLookup()
            if out[k] == nil { out[k] = value }
        }
        return out
    }()

    /// Fallback quando não há entrada no plist (inglês e termos comuns).
    private static let fallbackTable: [String: String] = [
        "rice": "🍚", "milk": "🥛", "bread": "🍞", "egg": "🥚", "eggs": "🥚",
        "coffee": "☕", "tea": "🫖", "water": "💧", "apple": "🍎", "banana": "🍌",
        "orange": "🍊", "cheese": "🧀", "butter": "🧈", "chicken": "🍗", "meat": "🥩",
        "fish": "🐟", "tomato": "🍅", "potato": "🥔", "carrot": "🥕", "lettuce": "🥬",
        "onion": "🧅", "garlic": "🧄", "pepper": "🫑", "corn": "🌽", "pasta": "🍝",
        "sugar": "🧂", "salt": "🧂", "oil": "🫒", "wine": "🍷", "beer": "🍺", "juice": "🧃",
        "chocolate": "🍫", "cookie": "🍪", "ice": "🧊", "cream": "🍦", "yogurt": "🥛",
        "soap": "🧼", "paper": "🧻", "battery": "🔋", "light": "💡",
    ]

    static func emoji(for itemName: String) -> String {
        let name = itemName.normalizedForEmojiLookup()
        guard !name.isEmpty else { return "🛒" }

        if let e = plistTable[name] { return e }

        for word in name.split(separator: " ").map(String.init) {
            let w = word.normalizedForEmojiLookup()
            if let e = plistTable[w] { return e }
        }

        let keysByLength = plistTable.keys.sorted { $0.count > $1.count }
        for key in keysByLength where name.contains(key) {
            if let e = plistTable[key] { return e }
        }

        for word in name.split(separator: " ").map(String.init) {
            let w = word.normalizedForEmojiLookup()
            if let e = fallbackTable[w] { return e }
        }

        return "🛒"
    }
}
