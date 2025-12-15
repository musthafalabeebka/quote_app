import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String baseUrl = 'https://api.quotable.io';

  Future<Quote> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random'));
      
      if (response.statusCode == 200) {
        return Quote.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Quote>> getQuotesByTag(String tag) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quotes?tags=$tag&limit=10'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((quote) => Quote.fromJson(quote)).toList();
      } else {
        throw Exception('Failed to load quotes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Quote> getQuoteOfTheDay() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random?maxLength=100'));
      
      if (response.statusCode == 200) {
        return Quote.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
