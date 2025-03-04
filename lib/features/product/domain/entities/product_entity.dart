import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double discount;
  final double rating;
  final String description;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.rating,
    required this.description,
  });

  // ✅ Método para convertir un objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "imageUrl": imageUrl,
      "price": price,
      "discount": discount,
      "rating": rating,
      "description": description,
    };
  }

  // ✅ Método para convertir JSON a un objeto `ProductEntity`
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json["id"] ?? "",
      name: json["name"] ?? "Sin nombre",
      imageUrl: json["imageUrl"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      discount: (json["discount"] ?? 0).toDouble(),
      rating: (json["rating"] ?? 0).toDouble(),
      description: json["description"] ?? "",
    );
  }

  @override
  List<Object?> get props =>
      [id, name, imageUrl, price, discount, rating, description];
}
