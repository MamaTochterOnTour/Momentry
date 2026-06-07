// -------------------- Models --------------------
class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final int tab;
  final String rcProductId;
  final String pdfUrl;
  final List<String> categories;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.tab,
    required this.rcProductId,
    required this.pdfUrl,
    required this.categories,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'description': description,
    'imageUrl': imageUrl,
    'tab': tab,
    'rcProductId': rcProductId,
    'pdfUrl': pdfUrl,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    tab: json['tab'],
    rcProductId: json['rcProductId'] ?? '',
    pdfUrl: json['pdfUrl'] ?? '',
    categories: List<String>.from(json['categories'] ?? []),
  );
}
