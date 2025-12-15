class Quote {
  final String id;
  final String content;
  final String author;
  final String? category;

  Quote({
    required this.id,
    required this.content,
    required this.author,
    this.category,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id']?.toString() ?? DateTime.now().toString(),
      content: json['quote'] ?? json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': content,
      'author': author,
      'category': category,
    };
  }
}