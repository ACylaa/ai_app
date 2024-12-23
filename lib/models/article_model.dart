class Article {
  final String? title;
  final String? summary;
  final String? imageUrl;
  final String? url;

  Article({
    this.title,
    this.summary,
    this.imageUrl,
    this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['image_url'],
      url: json['url'],
    );
  }
}
