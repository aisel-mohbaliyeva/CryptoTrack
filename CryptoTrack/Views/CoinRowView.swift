import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let isFavorite: Bool

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Circle().fill(Color(.systemGray5))
            }
            .frame(width: 38, height: 38)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.currentPrice, format: .currency(code: "USD"))
                    .font(.headline)
                Text(String(format: "%+.2f%%", coin.priceChange))
                    .font(.caption)
                    .foregroundStyle(coin.isPositive ? .green : .red)
            }

            if isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 2)
    }
}
