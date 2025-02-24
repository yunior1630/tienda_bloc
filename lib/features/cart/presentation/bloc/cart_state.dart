import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInicial extends CartState {}

class CartCargando extends CartState {}

class CartCargado extends CartState {
  final List<CartItemEntity> productosEnCarrito;

  CartCargado(this.productosEnCarrito);

  @override
  List<Object?> get props => [productosEnCarrito];
}

class CartError extends CartState {
  final String mensaje;

  CartError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
