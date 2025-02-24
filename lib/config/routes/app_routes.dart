import 'package:flutter/material.dart';
import 'package:tienda_bloc/features/product/domain/entities/product_entity.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/product/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String productDetail = '/productDetail';
  static const String cart = '/cart'; // <-- Nueva ruta del carrito

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case productDetail:
        final product = settings.arguments as ProductEntity;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        );
      case cart:
        return MaterialPageRoute(
            builder: (_) => const CartPage()); // <-- Ruta del carrito
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
