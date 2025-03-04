import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tienda_bloc/config/routes/app_routes.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_event.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_state.dart';
import 'package:tienda_bloc/features/product/presentation/bloc/product_event.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/auth_usecase.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/agregar_producto_usecase.dart';
import 'features/cart/domain/usecases/modificar_cantidad_usecase.dart';
import 'features/cart/domain/usecases/vaciar_carrito_usecase.dart';
import 'features/cart/domain/usecases/eliminar_producto_usecase.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/usecases/get_products_usecase.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

// 🔥 GlobalKey para manejar la navegación de forma global
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 🛠️ Inyección de dependencias
  final dependencies = _initializeDependencies();

  runApp(MyApp(dependencies: dependencies));
}

// 🔹 Función para inicializar todas las dependencias
Dependencies _initializeDependencies() {
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
    firestore: firestore,
  );

  final authRepository = AuthRepositoryImpl(authRemoteDataSource); // ✅ Agregado

  return Dependencies(
    signInWithGoogleUseCase: SignInWithGoogleUseCase(authRepository),
    signInWithEmailUseCase: SignInWithEmailUseCase(authRepository),
    signOutUseCase: SignOutUseCase(authRepository),
    getProductsUseCase: GetProductsUseCase(
      ProductRepositoryImpl(
        remoteDataSource: ProductRemoteDataSourceImpl(firestore: firestore),
      ),
    ),
    cartRepository: CartRepositoryImpl(
      firestore: firestore,
      firebaseAuth: firebaseAuth,
    ),
    firebaseAuth: firebaseAuth,
    authRepository: authRepository, // ✅ Agregado
  );
}

class MyApp extends StatelessWidget {
  final Dependencies dependencies;

  const MyApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signInWithGoogle: dependencies.signInWithGoogleUseCase,
            signInWithEmail: dependencies.signInWithEmailUseCase,
            signOut: dependencies.signOutUseCase,
            firebaseAuth: dependencies.firebaseAuth,
            authRepository: dependencies.authRepository, // ✅ Agregado
          )..add(CheckAuthEvent()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            getProducts: dependencies.getProductsUseCase,
          )..add(LoadProductsEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            agregarProducto:
                AgregarProductoUseCase(dependencies.cartRepository),
            eliminarProducto:
                EliminarProductoUseCase(dependencies.cartRepository),
            modificarCantidad:
                ModificarCantidadUseCase(dependencies.cartRepository),
            cartRepository: dependencies.cartRepository,
            vaciarCarrito: VaciarCarritoUseCase(dependencies.cartRepository),
          ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            navigatorKey.currentState
                ?.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tienda Bloc',
          theme: ThemeData(primarySwatch: Colors.blue),
          navigatorKey: navigatorKey, // 🔥 GlobalKey para navegación
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}

// 🔹 Clase que almacena las dependencias para mejor organización
class Dependencies {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignOutUseCase signOutUseCase;
  final GetProductsUseCase getProductsUseCase;
  final CartRepository cartRepository;
  final FirebaseAuth firebaseAuth;
  final AuthRepository authRepository; // ✅ Agregado

  Dependencies({
    required this.signInWithGoogleUseCase,
    required this.signInWithEmailUseCase,
    required this.signOutUseCase,
    required this.getProductsUseCase,
    required this.cartRepository,
    required this.firebaseAuth,
    required this.authRepository, // ✅ Agregado
  });
}
