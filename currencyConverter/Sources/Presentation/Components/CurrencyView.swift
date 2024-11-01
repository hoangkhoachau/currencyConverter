import SwiftUI

struct CurrencyView: View {
    let currency: Currency?
    init(_ currency: Currency?) {
        self.currency = currency
    }
    var body: some View {
        HStack {
            Text((currency?.shortName) ?? "UNK")
                .foregroundStyle(.gray)
                .font(.system(size: 20).monospaced())
                .minimumScaleFactor(0.0001)
            Image(systemName: "chevron.up.chevron.down")
                .foregroundStyle(.gray)
        }
        .padding(.trailing)
    }
}

