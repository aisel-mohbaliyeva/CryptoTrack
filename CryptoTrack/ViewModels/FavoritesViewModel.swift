import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteIDs: Set<String> = []

    private let storageKey = "favorite_coin_ids"

    init() { load() }

    func toggle(_ coin: Coin) {
        if favoriteIDs.contains(coin.id) {
            favoriteIDs.remove(coin.id)
        } else {
            favoriteIDs.insert(coin.id)
        }
        save()
    }

    func isFavorite(_ coin: Coin) -> Bool {
        favoriteIDs.contains(coin.id)
    }

    func favoriteCoins(from allCoins: [Coin]) -> [Coin] {
        allCoins.filter { favoriteIDs.contains($0.id) }
    }

    func clearAll() {
        favoriteIDs.removeAll()
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: storageKey)
    }

    private func load() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        favoriteIDs = Set(saved)
    }
}
