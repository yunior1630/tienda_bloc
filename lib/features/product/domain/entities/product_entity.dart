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

  @override
  List<Object?> get props =>
      [id, name, imageUrl, price, discount, rating, description];
}
