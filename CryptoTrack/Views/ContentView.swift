import SwiftUI

struct ContentView: View {
    @StateObject private var marketVM = MarketViewModel()
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var portfolioVM = PortfolioViewModel()

    var body: some View {
        TabView {
            MarketView(vm: marketVM, favoritesVM: favoritesVM)
                .tabItem { Label("Market", systemImage: "chart.bar.fill") }

            FavoritesView(vm: favoritesVM, allCoins: marketVM.allCoins)
                .tabItem { Label("Favorites", systemImage: "star.fill") }

            PortfolioView(vm: portfolioVM, allCoins: marketVM.allCoins)
                .tabItem { Label("Portfolio", systemImage: "briefcase.fill") }
        }
    }
}
