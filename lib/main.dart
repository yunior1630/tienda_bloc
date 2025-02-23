import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_event.dart';
import 'package:tienda_bloc/features/product/presentation/bloc/product_event.dart';
import 'config/routes/app_routes.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/usecases/auth_usecase.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/usecases/get_products_usecase.dart';
import 'auth_wrapper.dart'; // ← Este widget decidirá a dónde ir (Login o Home)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inyección de dependencias
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  final googleSignIn = GoogleSignIn();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final signInWithGoogleUseCase = SignInWithGoogleUseCase(authRepository);
  final signInWithEmailUseCase = SignInWithEmailUseCase(authRepository);
  final signOutUseCase = SignOutUseCase(authRepository);

  final productRemoteDataSource =
      ProductRemoteDataSourceImpl(firestore: firestore);
  final productRepository =
      ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);
  final getProductsUseCase = GetProductsUseCase(productRepository);

  runApp(MyApp(
    signInWithGoogleUseCase: signInWithGoogleUseCase,
    signInWithEmailUseCase: signInWithEmailUseCase,
    signOutUseCase: signOutUseCase,
    getProductsUseCase: getProductsUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignOutUseCase signOutUseCase;
  final GetProductsUseCase getProductsUseCase;

  MyApp({
    required this.signInWithGoogleUseCase,
    required this.signInWithEmailUseCase,
    required this.signOutUseCase,
    required this.getProductsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signInWithGoogle: signInWithGoogleUseCase,
            signInWithEmail: signInWithEmailUseCase,
            signOut: signOutUseCase,
          )..add(
              CheckAuthEvent()), // Verifica si el usuario está autenticado al iniciar
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(getProducts: getProductsUseCase)
            ..add(LoadProductsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Shop',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(), // ← Determina si va a LoginPage o HomePage
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
