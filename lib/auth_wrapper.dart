import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_state.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:tienda_bloc/features/product/presentation/pages/home_page.dart';
import 'package:tienda_bloc/features/authentication/presentation/pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return HomePage();
        } else if (state is Unauthenticated) {
          return const LoginPage(); // 🔥 Se muestra login si el usuario no está autenticado
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
