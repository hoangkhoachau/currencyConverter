import SwiftUI

struct inputView: View {
    let fieldNum: Int
    @Binding var selecting: Int?
    @ObservedObject var viewModel: Converter

    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Text(viewModel.field[fieldNum])
                .foregroundStyle(viewModel.inputPos == fieldNum ? .white : .gray)
                .font(.system(size: 200))
                .minimumScaleFactor(0.0001)
                .containerRelativeFrame(.vertical, count: 8, span: 1, spacing: 0)
                .padding(.vertical, -15)
            Button(
                action: {
                    selecting = fieldNum
                },
                label: {
                    CurrencyView(viewModel.fieldCurrency[fieldNum])
                }
            )
        }
    }
}

