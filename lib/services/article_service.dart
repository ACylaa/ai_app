import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ArticleService {
  static const String _apiUrl = 'http://192.168.0.113:5000/rss/fetch';

  static Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['articles'] != null && data['articles'] is List) {
          return (data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList();
        } else {
          throw Exception("Invalid data format: 'articles' field missing.");
        }
      } else {
        throw Exception('Error fetching articles: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
