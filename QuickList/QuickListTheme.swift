//
//  QuickListTheme.swift
//  QuickList
//

import SwiftUI

enum QuickListTheme {
    /// Fundo geral — rosa muito suave
    static let background = Color(red: 0.99, green: 0.94, blue: 0.96)
    /// Cartões / linhas
    static let card = Color.white
    /// Texto principal — ameixa escuro (legível sobre rosa)
    static let primaryText = Color(red: 0.22, green: 0.11, blue: 0.20)
    /// Acento principal — rosa vibrante
    static let accent = Color(red: 0.88, green: 0.38, blue: 0.58)
    /// Acento para pressionado / ênfase
    static let accentDeep = Color(red: 0.62, green: 0.22, blue: 0.45)
    /// Bordas e divisores suaves
    static let border = Color(red: 0.94, green: 0.78, blue: 0.88)
    static let divider = Color(red: 0.92, green: 0.82, blue: 0.90)
}

struct PinkTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(QuickListTheme.card)
            .foregroundStyle(QuickListTheme.primaryText)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(QuickListTheme.border, lineWidth: 1)
            )
    }
}
