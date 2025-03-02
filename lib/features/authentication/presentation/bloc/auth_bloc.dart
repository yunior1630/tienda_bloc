import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/authentication/domain/entities/user_entity.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_event.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_state.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase signInWithGoogle;
  final SignInWithEmailUseCase signInWithEmail;
  final SignOutUseCase signOut;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithEmail,
    required this.signOut,
  }) : super(AuthInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthEvent>(_onCheckAuth); // Nuevo evento para revisar autenticación
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError('Error al iniciar sesión con Google'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Estado de carga

    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError("El email y la contraseña son obligatorios"));
        return;
      }

      final user = await signInWithEmail(event.email, event.password);

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("Email o contraseña incorrectos"));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error al iniciar sesión";

      if (e.code == "user-not-found") {
        errorMessage = "El email no está registrado";
      } else if (e.code == "wrong-password") {
        errorMessage = "Contraseña incorrecta";
      } else if (e.code == "invalid-email") {
        errorMessage = "Email inválido";
      } else if (e.code == "too-many-requests") {
        errorMessage = "Demasiados intentos, intente más tarde";
      }

      // Agregar logs para depuración

      emit(AuthError(
          errorMessage)); // 🚨 Asegurar que `AuthError` se emite correctamente
    } catch (e) {
      emit(AuthError("Error inesperado, intente nuevamente."));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await signOut();
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(Authenticated(UserEntity(
          uid: user.uid, email: user.email, displayName: user.displayName)));
    } else {
      emit(Unauthenticated());
    }
  }
}
