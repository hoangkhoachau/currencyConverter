import Foundation

protocol CurrencyConverterApiService {
    func fetchCurrencies() async throws -> [String: String]
    func fetchRates() async throws -> (rates: [String: Double], updatedTime: Date)
}


enum APIError: Error {
    case timeout
    case invalidURL
    case invalidResponse
    case httpError
}
