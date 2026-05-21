import Foundation
import Combine

final class PortfolioViewModel: ObservableObject {
    @Published var holdings: [PortfolioItem] = []

    private let storageKey = "portfolio_holdings"

    init() { load() }

    func addOrUpdate(coinID: String, amount: Double) {
        if let index = holdings.firstIndex(where: { $0.id == coinID }) {
            if amount <= 0 {
                holdings.remove(at: index)
            } else {
                holdings[index].amount = amount
            }
        } else if amount > 0 {
            holdings.append(PortfolioItem(id: coinID, amount: amount))
        }
        save()
    }

    func amount(for coinID: String) -> Double {
        holdings.first(where: { $0.id == coinID })?.amount ?? 0
    }

    func totalValue(coins: [Coin]) -> Double {
        holdings.reduce(0) { total, item in
            let price = coins.first(where: { $0.id == item.id })?.currentPrice ?? 0
            return total + item.value(at: price)
        }
    }

    func clearAll() {
        holdings.removeAll()
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(holdings) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let items = try? JSONDecoder().decode([PortfolioItem].self, from: data) else { return }
        holdings = items
    }
}
