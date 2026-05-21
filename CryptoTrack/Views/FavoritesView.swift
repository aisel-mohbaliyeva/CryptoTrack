import SwiftUI

struct FavoritesView: View {
    @ObservedObject var vm: FavoritesViewModel
    let allCoins: [Coin]

    @State private var hapticTrigger = 0

    var body: some View {
        NavigationStack {
            let favorites = vm.favoriteCoins(from: allCoins)
            Group {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "star",
                        description: Text("Tap the star on any coin to add it here.")
                    )
                } else {
                    List(favorites) { coin in
                        CoinRowView(coin: coin, isFavorite: true)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    vm.toggle(coin)
                                    hapticTrigger += 1
                                } label: {
                                    Label("Remove", systemImage: "star.slash.fill")
                                }
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .sensoryFeedback(.impact, trigger: hapticTrigger)
            .toolbar {
                if !favorites.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear All", role: .destructive) {
                            vm.clearAll()
                        }
                    }
                }
            }
        }
    }
}
