//
//  ShoppingListPDFExporter.swift
//  QuickList
//

import UIKit

enum ShoppingListPDFExporter {
    private static let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
    private static let margin: CGFloat = 72
    private static let lineHeight: CGFloat = 24
    private static let titleFont = UIFont.boldSystemFont(ofSize: 22)
    private static let bodyFont = UIFont.systemFont(ofSize: 15)

    static func makePDF(items: [ShoppingItem], title: String = "Lista de Compras") -> Data? {
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { context in
            context.beginPage()
            var y = margin

            func newPageIfNeeded() {
                if y > pageRect.height - margin {
                    context.beginPage()
                    y = margin
                }
            }

            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.black,
            ]
            (title as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
            y += 36
            newPageIfNeeded()

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "pt_PT")
            let subtitle = dateFormatter.string(from: Date())
            let subAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.darkGray,
            ]
            (subtitle as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: subAttrs)
            y += 28
            newPageIfNeeded()

            if items.isEmpty {
                let empty = "Nenhum item na lista."
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: bodyFont,
                    .foregroundColor: UIColor.black,
                ]
                (empty as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: attrs)
                return
            }

            for item in items {
                newPageIfNeeded()
                let mark = item.comprado ? "✓" : "○"
                let icon = ItemEmojiResolver.emoji(for: item.nome)
                let line = "\(icon)  \(mark)  \(item.nome)  ·  \(item.quantidade)"
                let mutable = NSMutableAttributedString(string: line)
                let fullRange = NSRange(location: 0, length: mutable.length)
                mutable.addAttribute(.font, value: bodyFont, range: fullRange)
                mutable.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
                if item.comprado {
                    mutable.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: fullRange)
                }
                mutable.draw(at: CGPoint(x: margin, y: y))
                y += lineHeight
            }
        }
    }
}
