class Product {
  final String? id;
  final String? title;
  final String? image;
  final dynamic price;
  final dynamic ratings;

  final String? link;
  final String? category;
  Product({
    this.id,
    this.image,
    this.link,
    this.ratings,
    this.title,
    this.price,
    this.category,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'],
      title: json["title"],
      image: json["image"],
      link: json['link'],
      ratings: json['reviews'],
      price: json["price"],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'ratings': ratings,
      'price': price,
      'category': category,

      // 'link': link,
    };
  }
}
