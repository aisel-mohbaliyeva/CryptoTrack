import Foundation

struct PortfolioItem: Codable, Identifiable, Sendable {
    let id: String
    var amount: Double

    func value(at price: Double) -> Double {
        amount * price
    }
}
