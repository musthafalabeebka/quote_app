import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../widgets/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Quote> favorites;
  final Function(Quote) onRemove;

  const FavoritesScreen({
    Key? key,
    required this.favorites,
    required this.onRemove,
  }) : super(key: key);

  void _copyToClipboard(BuildContext context, Quote quote) {
    Clipboard.setData(
      ClipboardData(text: '"${quote.content}" - ${quote.author}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _shareQuote(Quote quote) {
    Share.share('"${quote.content}" - ${quote.author}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes (${favorites.length})'),
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding quotes you love',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final quote = favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                QuoteCard(quote: quote),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onRemove(quote),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(context, quote),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareQuote(quote),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}