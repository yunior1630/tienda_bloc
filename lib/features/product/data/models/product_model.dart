import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    required double discount,
    required double rating,
    required String description,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          price: price,
          discount: discount,
          rating: rating,
          description: description,
        );

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
