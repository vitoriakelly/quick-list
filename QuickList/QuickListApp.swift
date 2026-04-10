//
//  QuickListApp.swift
//  QuickList
//
//  Created by Vitória Kelly on 10/04/26.
//

import SwiftUI
import UIKit

@main
struct QuickListApp: App {
    @State private var listsStore = ShoppingListsStore()

    init() {
        let plum = UIColor(red: 0.22, green: 0.11, blue: 0.20, alpha: 1)
        let bg = UIColor(red: 0.99, green: 0.94, blue: 0.96, alpha: 1)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bg
        appearance.largeTitleTextAttributes = [.foregroundColor: plum]
        appearance.titleTextAttributes = [.foregroundColor: plum]
        let nav = UINavigationBar.appearance()
        nav.standardAppearance = appearance
        nav.scrollEdgeAppearance = appearance
        nav.compactAppearance = appearance
        nav.tintColor = UIColor(red: 0.88, green: 0.38, blue: 0.58, alpha: 1)
    }

    var body: some Scene {
        WindowGroup {
            MinhasListasView(store: listsStore)
                .tint(QuickListTheme.accent)
        }
    }
}
