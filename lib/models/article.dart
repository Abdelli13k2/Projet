class Article {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category; // extrait du champ category.name
  final String image; // première image de la liste images

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> m) {
    return Article(
      id: m['id'] as int,
      title: m['title'] as String,
      description: m['description'] as String,
      price: (m['price'] as num).toDouble(),
      category: m['category'] is Map<String, dynamic>
          ? (m['category']['name'] ?? '').toString()
          : m['category'].toString(),
      image: m['images'] is List && (m['images'] as List).isNotEmpty
          ? (m['images'] as List).first.toString()
          : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'category': this.category,
      'image': this.image
    };
  }

  //static fromJson(item) {

  // }
}
