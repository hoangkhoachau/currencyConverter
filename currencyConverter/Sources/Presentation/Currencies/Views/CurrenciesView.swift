import Foundation
import SwiftUI

struct CurrenciesView: View {
    @State var searchText: String = ""
    @ObservedObject var viewModel: Converter
    @Binding var fieldNum: Int?

    var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return viewModel.currencies
        } else {
            return viewModel.currencies.filter {
                $0.shortName.localizedCaseInsensitiveContains(searchText)
                    || $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var updatedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: viewModel.updatedTime, relativeTo: Date())
    }

    var body: some View {
        VStack(alignment: .trailing) {
            Button(
                action: {
                    fieldNum = nil
                },
                label: {
                    Text("Done")
                        .foregroundStyle(.orange)
                }
            ).padding()
            searchBar
            currenciesList
            bottomBar
        }
        .background(Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255).ignoresSafeArea())
        .presentationCornerRadius(20)
    }

    var currenciesList: some View {
        List {
            ForEach(filteredCurrencies) { currency in
                let selected =
                    fieldNum != nil && currency.id == viewModel.fieldCurrency[fieldNum!]?.id
                HStack {
                    VStack(alignment: .leading) {
                        Text(currency.name)
                            .foregroundStyle(selected ? Color.orange : Color.white)
                        Text(currency.shortName)
                            .font(.subheadline)
                            .foregroundStyle(selected ? Color.orange : Color.gray)
                    }
                    Spacer()
                    if selected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.orange)
                    }
                }
                .listRowBackground(Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255))
                .onTapGesture {
                    viewModel.fieldCurrency[fieldNum!] = currency
                    if let currency0 = viewModel.fieldCurrency[0],
                        let currency1 = viewModel.fieldCurrency[1]
                    {
                        UserDefaults.standard.set(
                            currency0.shortName,
                            forKey: "fieldCurrency1")
                        UserDefaults.standard.set(
                            currency1.shortName,
                            forKey: "fieldCurrency2")
                    }
                    fieldNum = nil
                }
            }

        }
        .refreshable {
            await viewModel.getCurrencies()
        }
        .scrollContentBackground(.hidden)
    }

    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(
                "", text: $searchText,
                prompt: Text("Search all units").foregroundStyle(.white.opacity(0.5))

            )
            .foregroundColor(.white)
            .textFieldStyle(PlainTextFieldStyle())

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    var bottomBar: some View {
        HStack {
            Text("open")
                .bold()
                .foregroundColor(.gray)
            Text("exchange rates")
                .foregroundColor(.gray)
            Spacer()
            Text("Updated \(updatedTime)")
                .font(.footnote)
                .foregroundColor(.gray)

        }
        .padding()
        .background(Color.black.opacity(0.9))
    }

}
