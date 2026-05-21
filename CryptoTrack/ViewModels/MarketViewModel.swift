import Foundation
import Combine

final class MarketViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var filteredCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .rank
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    enum SortOption: String, CaseIterable {
        case rank = "Rank"
        case price = "Price"
        case change = "24h Change"
        case marketCap = "Market Cap"
    }

    init() {
        setupSearchAndSort()
        fetchCoins()
    }

    private func setupSearchAndSort() {
        Publishers.CombineLatest3($allCoins, $searchText, $sortOption)
            .map { coins, query, sort -> [Coin] in
                var result = query.isEmpty ? coins : coins.filter {
                    $0.name.localizedCaseInsensitiveContains(query) ||
                    $0.symbol.localizedCaseInsensitiveContains(query)
                }
                switch sort {
                case .rank:       result.sort { ($0.marketCapRank ?? Int.max) < ($1.marketCapRank ?? Int.max) }
                case .price:      result.sort { $0.currentPrice > $1.currentPrice }
                case .change:     result.sort { $0.priceChange > $1.priceChange }
                case .marketCap:  result.sort { ($0.marketCap ?? 0) > ($1.marketCap ?? 0) }
                }
                return result
            }
            .assign(to: &$filteredCoins)
    }

    func fetchCoins() {
        isLoading = true
        errorMessage = nil
        CryptoService.shared.fetchMarkets()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }

    @MainActor
    func fetchCoinsAsync() async {
        isLoading = true
        errorMessage = nil
        do {
            let coins = try await CryptoService.shared.fetchMarketsAsync()
            allCoins = coins
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
