import 'package:flutter/material.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/product/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String productDetail = '/productDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case productDetail:
        return MaterialPageRoute(builder: (_) => ProductDetailPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
