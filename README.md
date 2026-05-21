# CryptoTrack

iOS app built with SwiftUI for tracking cryptocurrency prices, managing favorites, and building a portfolio. Powered by CoinGecko API.

## Screenshots

<p align="center">
  <img src="Screenshots/market.png" width="230" alt="Market">
  <img src="Screenshots/detail.png" width="230" alt="Coin Detail">
  <img src="Screenshots/favorites.png" width="230" alt="Favorites">
  <img src="Screenshots/portfolio.png" width="230" alt="Portfolio">
</p>

## Features

- **Market** — Live prices for top 50 cryptocurrencies with search and sort (rank, price, 24h change, market cap)
- **Coin Detail** — Price chart (7-day sparkline), 24h high/low, market cap, volume
- **Favorites** — Star any coin to save it, swipe to remove
- **Portfolio** — Add holdings, track total value in USD, swipe to delete
- **Pull to Refresh** — Async data refresh with native SwiftUI indicator
- **Haptic Feedback** — Native SwiftUI sensory feedback on interactions
- **Offline Persistence** — Favorites and portfolio saved locally via UserDefaults

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI, Charts |
| Architecture | MVVM |
| Networking | URLSession (async/await) |
| Reactive | Combine (search/sort pipeline) |
| Persistence | UserDefaults |
| API | CoinGecko REST API |
| Min. iOS | 17.0 |

## Project Structure

```
CryptoTrack/
├── Models/
│   ├── Coin.swift              # Cryptocurrency data model
│   └── PortfolioItem.swift     # Portfolio holding model
├── Services/
│   └── CryptoService.swift     # API client (CoinGecko)
├── ViewModels/
│   ├── MarketViewModel.swift   # Market list logic + search/sort
│   ├── FavoritesViewModel.swift# Favorites management
│   └── PortfolioViewModel.swift# Portfolio CRUD
├── Views/
│   ├── ContentView.swift       # Tab navigation
│   ├── MarketView.swift        # Market list screen
│   ├── CoinDetailView.swift    # Coin detail + sparkline chart
│   ├── CoinRowView.swift       # Reusable coin list row
│   ├── FavoritesView.swift     # Favorites screen
│   └── PortfolioView.swift     # Portfolio screen
└── Assets.xcassets/
```

## API

[CoinGecko API v3](https://www.coingecko.com/en/api) — `/coins/markets` endpoint

**Parameters:** `vs_currency=usd`, `per_page=50`, `sparkline=true`, `price_change_percentage=24h`

## License

This project is available under the MIT License.
