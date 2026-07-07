import SwiftUI

/// Unique visual identity for Litterly.
enum Theme {
    static let background = Color(red: 0.125, green: 0.137, blue: 0.169)
    static let accent = Color(red: 0.353, green: 0.784, blue: 0.847)
    static let secondary = Color(red: 0.624, green: 0.827, blue: 0.863)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .default).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .default).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .default)
    static let captionFont = Font.system(.caption, design: .default)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
