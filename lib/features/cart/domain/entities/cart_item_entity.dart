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

  @override
  List<Object?> get props => [producto, cantidad];
}
