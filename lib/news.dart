import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class NewsItem {
  final String title;
  final String description;
  final String imageUrl;
  final String url;

  NewsItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['headline'] ?? '',
      description: json['body'] ?? '',
      imageUrl: json['thumbnail'] ?? '',
      url: json['url'] ?? '',
    );
  }
}


class _NewsPageState extends State<NewsPage> {
  List<NewsItem> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://search.prod.di.api.cnn.io/content?q=nature&size=10&from=0&page=1&sort=newest&request_id=stellar-search-82614e33-feec-4e75-a26b-5a06ee1bbc8b&site=cnn');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> result = json.decode(response.body)['result'];
      setState(() {
        newsList = result.map((e) => NewsItem.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(news.imageUrl),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        news.description,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        news.url,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}