import SwiftUI

enum ColorName: String, CaseIterable {
    case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink
    case brown, white, gray, black, primary, secondary, tertiary, quaternary, accent
    case custom

    var color: Color {
        switch self {
            case .tertiary: return Color(nsColor: .tertiaryLabelColor)
            case .quaternary: return Color(nsColor: .quaternaryLabelColor)
            case .custom: return Color(red: 0.5, green: 0.5, blue: 0.5)
            default: return Color(rawValue)
        }
    }
}

@Observable
final class ColorSwatchManager {
    static func swatch(for name: ColorName) -> NSImage? {
        guard let image = NSImage(systemSymbolName: "rectangle.fill", accessibilityDescription: nil) else {
            return nil
        }
        image.isTemplate = false

        image.lockFocus()
        NSColor(name.color).set()
        NSRect(origin: .zero, size: image.size).fill(using: .sourceIn)
        image.unlockFocus()

        return image
    }
}

extension View {
    func colorPicker(selection: Binding<Color>, label: String = "Color") -> some View {
        Picker(label, selection: selection) {
            ForEach(ColorName.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { name in
                HStack {
                    if let swatch = ColorSwatchManager.swatch(for: name) {
                        Image(nsImage: swatch)
                        Text(name.rawValue.capitalized)
                    }
                }
                .tag(name.color)
            }
        }
        .labelsHidden()
    }
}
