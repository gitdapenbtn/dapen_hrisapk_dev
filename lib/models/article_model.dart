class ArticleModel {
  final int id;
  final String title;
  final String content;
  final String featuredImage;
  final String? description;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.featuredImage,
    this.description,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> data) {
    return ArticleModel(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      featuredImage: data['featured_image_url'],
      description: data['description'],
    );
  }
}
