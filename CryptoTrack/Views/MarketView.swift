import SwiftUI

struct MarketView: View {
    @ObservedObject var vm: MarketViewModel
    @ObservedObject var favoritesVM: FavoritesViewModel

    @State private var showError = false

    var body: some View {
        NavigationStack {
            List(vm.filteredCoins) { coin in
                NavigationLink {
                    CoinDetailView(coin: coin, favoritesVM: favoritesVM)
                } label: {
                    CoinRowView(coin: coin, isFavorite: favoritesVM.isFavorite(coin))
                }
            }
            .listStyle(.plain)
            .searchable(text: $vm.searchText, prompt: "Search coins")
            .navigationTitle("Market")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(MarketViewModel.SortOption.allCases, id: \.self) { option in
                            Button {
                                vm.sortOption = option
                            } label: {
                                HStack {
                                    Text(option.rawValue)
                                    if vm.sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .overlay {
                if vm.isLoading && vm.allCoins.isEmpty {
                    ProgressView()
                }
            }
            .refreshable {
                await vm.fetchCoinsAsync()
            }
            .onChange(of: vm.errorMessage) { _, message in
                showError = message != nil
            }
            .alert("Failed to load", isPresented: $showError) {
                Button("Try Again") { vm.fetchCoins() }
                Button("Cancel", role: .cancel) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}
