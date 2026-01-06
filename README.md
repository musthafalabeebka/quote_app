# Flutter Quote App

A simple Flutter application that fetches and displays random inspirational quotes from an API.

## Features

- 📱 Fetch random quotes from API
- 💾 Save favorite quotes locally
- 🎨 Beautiful, modern UI
- 🔄 Pull to refresh
- 📋 Copy quotes to clipboard
- 🌓 Dark mode support
- 📤 Share quotes

## API Used

This app uses the [Quotable API](https://api.quotable.io/) - a free, open-source quotations API.

## Screenshots

![Quote App](screenshot.png)

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Internet connection (for fetching quotes)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/musthafalabeebka/flutter-quote-app.git
cd flutter-quote-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # Entry point
├── models/
│   └── quote.dart         # Quote model
├── services/
│   └── quote_service.dart # API service
├── screens/
│   ├── home_screen.dart   # Main screen
│   └── favorites_screen.dart # Favorites screen
└── widgets/
    └── quote_card.dart    # Quote card widget
```

## Dependencies

- `http`: For API requests
- `shared_preferences`: For local storage
- `share_plus`: For sharing quotes

## API Documentation

The app uses the [Quotable API](https://github.com/lukePeavey/quotable):

- `GET /random` - Get a random quote
- `GET /quotes?tags=tag` - Get quotes by tag

## Features Explained

1. **Random Quotes**: Fetches random inspirational quotes
2. **Favorites**: Save your favorite quotes locally
3. **Copy & Share**: Easily copy or share quotes
4. **Pull to Refresh**: Swipe down to get a new quote
5. **Beautiful UI**: Gradient cards with quote formatting
6. **Tags**: Shows quote categories

## Contributing

Pull requests are welcome! For major changes, please open an issue first.

## License

This project is open source and available under the [MIT License](LICENSE).

## Author

Your Name - [Your GitHub Profile](https://github.com/yourusername)
