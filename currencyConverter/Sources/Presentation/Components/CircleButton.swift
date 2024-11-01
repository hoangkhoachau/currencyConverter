import SwiftUI

struct CButton: View {
    let symbol: String
    let color: Color
    let onTap: () -> Void
    init(
        _ symbol: String,
        _ color: Color = Color(red: 41 / 255, green: 41 / 255, blue: 43 / 255),
        onTap: @escaping () -> Void = {}
    ) {
        self.symbol = symbol
        self.color = color
        self.onTap = onTap
    }
    var body: some View {
        Button(
            action: onTap,
            label: {
                Circle()
                    .fill(color)
                    .overlay {
                        Text(symbol)
                            .foregroundStyle(.white)
                            .font(.system(size: 200))
                            .minimumScaleFactor(0.0001)
                            .containerRelativeFrame(.vertical, count: 16, span: 1, spacing: 0)
                    }
            }
        )
    }
}

