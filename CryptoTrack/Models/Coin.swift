import Foundation

struct Coin: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Int?
    let priceChangePercentage24H: Double?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let sparklineIn7D: SparklineData?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case sparklineIn7D = "sparkline_in_7d"
    }

    var priceChange: Double { priceChangePercentage24H ?? 0 }
    var isPositive: Bool { priceChange >= 0 }
    var sparklinePrices: [Double] { sparklineIn7D?.price ?? [] }
}

struct SparklineData: Codable, Hashable, Sendable {
    let price: [Double]
}
