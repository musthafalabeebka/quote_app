import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String baseUrl = 'https://thequoteshub.com/api';

  Future<Quote> getRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quote/random'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Quote.fromJson(data);
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quote: $e');
    }
  }

  Future<List<Quote>> getQuotesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quotes/category/$category'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((quote) => Quote.fromJson(quote)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load quotes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Quote> getQuoteOfTheDay() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quote/today'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Quote.fromJson(data);
      } else {
        // Fallback to random quote if today endpoint doesn't work
        return await getRandomQuote();
      }
    } catch (e) {
      // Fallback to random quote
      return await getRandomQuote();
    }
  }
}