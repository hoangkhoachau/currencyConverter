import Foundation


class OpenExchangeRates: CurrencyConverterApiService {
    private let appId = API.key // Use a secure way to store your API key
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        self.session = URLSession(configuration: configuration)
    }

    func fetchCurrencies() async throws -> [String: String] {
        let urlString = "https://openexchangerates.org/api/currencies.json?app_id=\(appId)"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw APIError.httpError
            }

            let decodeData = try JSONDecoder().decode([String: String].self, from: data)
            return decodeData
        } catch {
            if (error as NSError).code == NSURLErrorTimedOut {
                throw APIError.timeout
            } else {
                throw error
            }
        }
    }

    func fetchRates() async throws -> (rates: [String: Double], updatedTime: Date) {
        let urlString = "https://openexchangerates.org/api/latest.json?app_id=\(appId)"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw APIError.httpError
            }

            let decodeData = try JSONDecoder().decode(LatestApiModel.self, from: data)
            return (
                rates: decodeData.rates,
                updatedTime: Date(timeIntervalSince1970: Double(decodeData.timestamp))
            )
        } catch {
            if (error as NSError).code == NSURLErrorTimedOut {
                throw APIError.timeout
            } else {
                throw error
            }
        }
    }
}


