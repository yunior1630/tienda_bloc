import 'package:flutter/material.dart';
import 'package:tienda_bloc/features/authentication/presentation/pages/login_page.dart';
import 'package:tienda_bloc/features/product/presentation/pages/home_page.dart';
import 'package:tienda_bloc/features/product/presentation/pages/product_detail_page.dart';
import 'package:tienda_bloc/features/cart/presentation/pages/cart_page.dart';
import 'package:tienda_bloc/features/product/data/models/product_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String productDetail = '/productDetail';
  static const String cart = '/cart';
  static const String category = '/category';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case productDetail:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: product),
        );
      // case category:
      //   final category = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (context) => CategoryPage(category: category),
      //   );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
