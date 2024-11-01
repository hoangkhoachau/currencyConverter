import Foundation

struct LatestApiModel: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}

typealias currencyShortName = [String: String]
