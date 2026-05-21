import SwiftUI

struct PortfolioView: View {
    @ObservedObject var vm: PortfolioViewModel
    let allCoins: [Coin]

    @State private var selectedCoinID: String?
    @State private var amountText = ""
    @State private var hapticTrigger = 0

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Value")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(vm.totalValue(coins: allCoins), format: .currency(code: "USD"))
                            .font(.title.bold())
                    }
                    .padding(.vertical, 4)
                }

                if !vm.holdings.isEmpty {
                    Section("Holdings") {
                        ForEach(vm.holdings) { item in
                            if let coin = allCoins.first(where: { $0.id == item.id }) {
                                holdingRow(item: item, coin: coin)
                            }
                        }
                    }
                }

                Section("Add / Update") {
                    Picker("Select Coin", selection: $selectedCoinID) {
                        Text("Choose a coin").tag(String?.none)
                        ForEach(allCoins) { coin in
                            Text("\(coin.name) (\(coin.symbol.uppercased()))").tag(Optional(coin.id))
                        }
                    }

                    if let id = selectedCoinID {
                        HStack {
                            TextField("Amount", text: $amountText)
                                .keyboardType(.decimalPad)
                            let existing = vm.amount(for: id)
                            if existing > 0 {
                                Text(String(format: "Now: %.4f", existing))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Button("Save") {
                            guard let amount = Double(amountText) else { return }
                            vm.addOrUpdate(coinID: id, amount: amount)
                            hapticTrigger += 1
                            selectedCoinID = nil
                            amountText = ""
                        }
                        .disabled(amountText.isEmpty || Double(amountText) == nil)
                    }
                }
            }
            .navigationTitle("Portfolio")
            .sensoryFeedback(.impact, trigger: hapticTrigger)
        }
    }

    private func holdingRow(item: PortfolioItem, coin: Coin) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Circle().fill(Color(.systemGray5))
            }
            .frame(width: 34, height: 34)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name).font(.headline)
                Text(String(format: "%.4f %@", item.amount, coin.symbol.uppercased()))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(item.value(at: coin.currentPrice), format: .currency(code: "USD"))
                .bold()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                vm.addOrUpdate(coinID: item.id, amount: 0)
                hapticTrigger += 1
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
}
