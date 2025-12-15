import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteService _quoteService = QuoteService();
  Quote? _currentQuote;
  bool _isLoading = false;
  List<Quote> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchQuote();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List<dynamic> decoded = json.decode(favoritesJson);
      setState(() {
        _favorites = decoded.map((item) => Quote.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_favorites.map((q) => q.toJson()).toList());
    await prefs.setString('favorites', encoded);
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quote = await _quoteService.getRandomQuote();
      setState(() {
        _currentQuote = quote;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _toggleFavorite() {
    if (_currentQuote == null) return;

    setState(() {
      final index = _favorites.indexWhere((q) => q.id == _currentQuote!.id);
      if (index != -1) {
        _favorites.removeAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        _favorites.add(_currentQuote!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    });
    _saveFavorites();
  }

  bool _isFavorite() {
    if (_currentQuote == null) return false;
    return _favorites.any((q) => q.id == _currentQuote!.id);
  }

  void _copyToClipboard() {
    if (_currentQuote != null) {
      Clipboard.setData(
        ClipboardData(text: '"${_currentQuote!.content}" - ${_currentQuote!.author}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
  }

  void _shareQuote() {
    if (_currentQuote != null) {
      Share.share('"${_currentQuote!.content}" - ${_currentQuote!.author}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Badge(
              label: Text(_favorites.length.toString()),
              isLabelVisible: _favorites.isNotEmpty,
              child: const Icon(Icons.favorite),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favorites: _favorites,
                    onRemove: (quote) {
                      setState(() {
                        _favorites.removeWhere((q) => q.id == quote.id);
                      });
                      _saveFavorites();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchQuote,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentQuote == null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Failed to load quote'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchQuote,
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                QuoteCard(quote: _currentQuote!),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite() ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(_isFavorite() ? 'Favorited' : 'Favorite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFavorite()
                            ? Colors.red
                            : null,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _shareQuote,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _fetchQuote,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Quote'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}