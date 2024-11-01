import Foundation
import SwiftUI

class Converter: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var fieldCurrency: [Currency?] = [nil, nil]
    @Published var field: [String] = ["0", "0"]
    @Published var inputPos: Int = 0
    @Published var updatedTime: Date = Date(timeIntervalSince1970: 0)

    @MainActor
    init() {
        UserDefaults.standard.register(defaults: ["fieldCurrency1": "USD", "fieldCurrency2": "VND"])
        Task {
            await getCurrencies(from: LocalCache())
            let field1Name = UserDefaults.standard.string(forKey: "fieldCurrency1")
            let field2Name = UserDefaults.standard.string(forKey: "fieldCurrency2")
            fieldCurrency[0] = currencies.first { $0.shortName == field1Name }
            fieldCurrency[1] = currencies.first { $0.shortName == field2Name }
            await getCurrencies()

        }
    }

    var outputPos: Int {
        inputPos == 0 ? 1 : 0
    }

    func insert(_ c: Character) {
        if field[inputPos].last?.isLetter == true
            || (field[inputPos] == "0" && c.isNumber)
        {
            field[inputPos] = String(c)
        } else {
            field[inputPos].append(c)
        }
        calOutput()
    }

    func remove() {
        if field[inputPos].count > 1
        {_ = field[inputPos].popLast()}
        calOutput()
    }

    func clear() {
        field[inputPos] = "0"
        field[outputPos] = "0"
        calOutput()
    }

    func calInput() {
        do {
            field[inputPos] = try formatNum(evaluate())
        } catch CalculateError.invalidExpression {
            field[inputPos] = "Invalid Expression"
        } catch CalculateError.divideByZero {
            field[inputPos] = "Divide By Zero"
        } catch let error {
            print(String(describing: error))
        }
    }

    func calOutput() {
        do {
            var result = try evaluate()
            if fieldCurrency[inputPos] != nil && fieldCurrency[outputPos] != nil {
                result = convert(
                    result, from: fieldCurrency[inputPos]!, to: fieldCurrency[outputPos]!)
            }
            field[outputPos] = formatNum(result)
        } catch CalculateError.invalidExpression {
        } catch CalculateError.divideByZero {
            field[outputPos] = "Divide By Zero"
        } catch let error {
            print(String(describing: error))
        }
    }

    private func formatNum(_ num: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: num))!
    }

    private func evaluate() throws -> Double {
        let calculator = Calculate()
        return try calculator.evaluate(field[inputPos])
    }

    func convert(
        _ amount: Double, from currencyA: Currency, to currencyB: Currency
    ) -> Double {
        return amount / currencyA.ratesOnUSD! * currencyB.ratesOnUSD!
    }

    func swapCurrency() {
        inputPos = inputPos == 0 ? 1 : 0
        let temp = field[0]
        field[0] = field[1]
        field[1] = temp
        calOutput()
    }

    func getCurrencies(from api: CurrencyConverterApiService = OpenExchangeRates()) async {
        do {
            let (rates, updatedTime) = try await api.fetchRates()
            let temp = try await api.fetchCurrencies().map { (shortName, name) in
                Currency(name: name, shortName: shortName, ratesOnUSD: rates[shortName])
            }
            DispatchQueue.main.async {
                self.updatedTime = updatedTime
                self.currencies = temp
            }
        } catch is APIError {
            await getCurrencies(from: LocalCache())
        } catch {
            print(error)
        }
    }
}
