/// Blog post model
class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String category;
  final DateTime publishedDate;
  final String imageUrl;
  final String author;

  BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.publishedDate,
    required this.imageUrl,
    required this.author,
  });
}
