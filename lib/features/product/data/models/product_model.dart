import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.price,
    required super.discount,
    required super.rating,
    required super.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      discount: json['discount'].toDouble(),
      rating: json['rating'].toDouble(),
      description: json['description'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "price": price,
      "discount": discount,
      "rating": rating,
      "description": description,
    };
  }
}
