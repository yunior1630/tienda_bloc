import 'package:equatable/equatable.dart';
import 'package:tienda_bloc/features/product/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity producto;
  final int cantidad;

  const CartItemEntity({
    required this.producto,
    required this.cantidad,
  });

  CartItemEntity copyWith({int? cantidad}) {
    return CartItemEntity(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  // ✅ Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "producto": producto.toJson(),
      "cantidad": cantidad,
    };
  }

  // ✅ Método para convertir desde JSON
  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      producto: ProductEntity.fromJson(json["producto"]),
      cantidad: json["cantidad"],
    );
  }

  @override
  List<Object?> get props => [producto, cantidad];
}
