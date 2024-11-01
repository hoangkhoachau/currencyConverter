import Foundation

class LocalCache: CurrencyConverterApiService {
    init() {
        // default data
        let currencies = [
            Currency(name: "United States Dollar", shortName: "USD", ratesOnUSD: 1),
            Currency(name: "Euro", shortName: "EUR", ratesOnUSD: 0.85),
            Currency(name: "Japanese Yen", shortName: "JPY", ratesOnUSD: 110.0),
            Currency(name: "British Pound Sterling", shortName: "GBP", ratesOnUSD: 0.72),
            Currency(name: "Vietnamese Dong", shortName: "VND", ratesOnUSD: 23000.0),
            Currency(name: "Chinese Yuan", shortName: "CNY", ratesOnUSD: 6.5),
            Currency(name: "South Korean Won", shortName: "KRW", ratesOnUSD: 1200.0),
            Currency(name: "Australian Dollar", shortName: "AUD", ratesOnUSD: 1.3),
            Currency(name: "Canadian Dollar", shortName: "CAD", ratesOnUSD: 1.25),
            Currency(name: "Swiss Franc", shortName: "CHF", ratesOnUSD: 0.92),
            Currency(name: "Hong Kong Dollar", shortName: "HKD", ratesOnUSD: 7.8),
            Currency(name: "New Zealand Dollar", shortName: "NZD", ratesOnUSD: 1.4),
        ]
        let updatedTime = Date(timeIntervalSince1970: 1602329410)
        UserDefaults.standard.register(defaults: [
            "currencies": try! JSONEncoder().encode(currencies),
            "updatedTime": updatedTime,
        ])

    }
    func fetchCurrencies() async throws -> [String: String] {
        if let data = UserDefaults.standard.data(forKey: "currencies"),
            let currencies = try? JSONDecoder().decode([Currency].self, from: data)
        {
            return currencies.reduce(into: [:]) { result, currency in
                result[currency.shortName] = currency.name
            }
        } else {
            throw APIError.invalidResponse
        }
    }

    func fetchRates() async throws -> (rates: [String: Double], updatedTime: Date) {
        if let data = UserDefaults.standard.data(forKey: "currencies"),
            let updatedTime = UserDefaults.standard.object(forKey: "updatedTime") as? Date,
            let currencies = try? JSONDecoder().decode([Currency].self, from: data)
        {
            return (
                rates: currencies.reduce(into: [:]) { result, currency in
                    result[currency.shortName] = currency.ratesOnUSD
                }, updatedTime: updatedTime
            )
        } else {
            throw APIError.invalidResponse
        }
    }

}
