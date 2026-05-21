import SwiftUI
import Charts

struct CoinDetailView: View {
    let coin: Coin
    @ObservedObject var favoritesVM: FavoritesViewModel

    @State private var hapticTrigger = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                priceSection

                if !coin.sparklinePrices.isEmpty {
                    sparklineChart
                }

                statsSection
            }
            .padding()
        }
        .navigationTitle(coin.symbol.uppercased())
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.impact, trigger: hapticTrigger)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesVM.toggle(coin)
                    hapticTrigger += 1
                } label: {
                    Image(systemName: favoritesVM.isFavorite(coin) ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                }
            }
        }
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Circle().fill(Color(.systemGray5))
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name).font(.title2.bold())
                if let rank = coin.marketCapRank {
                    Text("Rank #\(rank)").foregroundStyle(.secondary).font(.subheadline)
                }
            }
        }
    }

    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(coin.currentPrice, format: .currency(code: "USD"))
                .font(.title.bold())
            Text(String(format: "%+.2f%% (24h)", coin.priceChange))
                .foregroundStyle(coin.isPositive ? .green : .red)
                .font(.subheadline)
        }
    }

    private var sparklineChart: some View {
        let prices = coin.sparklinePrices
        return Chart {
            ForEach(Array(prices.enumerated()), id: \.offset) { i, price in
                LineMark(
                    x: .value("Hour", i),
                    y: .value("Price", price)
                )
                .foregroundStyle(coin.isPositive ? Color.green : Color.red)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 140)
        .padding(.vertical, 8)
    }

    private var statsSection: some View {
        let stats: [(String, String)] = {
            var s: [(String, String)] = []
            if let cap = coin.marketCap { s.append(("Market Cap", formatLarge(cap))) }
            if let high = coin.high24H { s.append(("24h High", high.formatted(.currency(code: "USD")))) }
            if let low = coin.low24H { s.append(("24h Low", low.formatted(.currency(code: "USD")))) }
            if let vol = coin.totalVolume { s.append(("Volume (24h)", formatLarge(vol))) }
            return s
        }()

        return VStack(spacing: 0) {
            ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                HStack {
                    Text(stat.0).foregroundStyle(.secondary)
                    Spacer()
                    Text(stat.1).bold()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if index < stats.count - 1 {
                    Divider().padding(.leading, 16)
                }
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func formatLarge(_ value: Double) -> String {
        switch value {
        case 1_000_000_000_000...: return String(format: "$%.2fT", value / 1_000_000_000_000)
        case 1_000_000_000...:     return String(format: "$%.2fB", value / 1_000_000_000)
        case 1_000_000...:         return String(format: "$%.2fM", value / 1_000_000)
        default:                   return value.formatted(.currency(code: "USD"))
        }
    }
}
