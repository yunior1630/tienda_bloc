import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_state.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/product/presentation/pages/home_page.dart';
import 'features/authentication/presentation/pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return HomePage();
        } else if (state is Unauthenticated) {
          return LoginPage();
        }
        return LoginPage();
      },
    );
  }
}
