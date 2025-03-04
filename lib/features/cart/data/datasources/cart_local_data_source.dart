import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartLocalDataSource {
  static const String cartKey = "CART_ITEMS";

  Future<void> guardarCarrito(List<CartItemEntity> carrito) async {
    final prefs = await SharedPreferences.getInstance();
    final carritoJson =
        jsonEncode(carrito.map((item) => item.toJson()).toList());
    await prefs.setString(cartKey, carritoJson);
  }

  Future<List<CartItemEntity>> cargarCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    final carritoJson = prefs.getString(cartKey);

    if (carritoJson == null) return [];

    final List<dynamic> carritoMap = jsonDecode(carritoJson);
    return carritoMap.map((item) => CartItemEntity.fromJson(item)).toList();
  }

  Future<void> limpiarCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }
}
