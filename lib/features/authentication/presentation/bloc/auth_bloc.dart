import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/authentication/domain/entities/user_entity.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_event.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase signInWithGoogle;
  final SignInWithEmailUseCase signInWithEmail;
  final SignOutUseCase signOut;
  final AuthRepository authRepository; // ✅ Agregado

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithEmail,
    required this.signOut,
    required this.authRepository, // ✅ Agregado
    required FirebaseAuth firebaseAuth,
  }) : super(AuthInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthEvent>(_onCheckAuth);
    on<SignInWithPinEvent>(_onSignInWithPin); // ✅ Agregado
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
    emit(AuthLoading());
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
    } catch (e) {
      emit(AuthError("Error inesperado, intente nuevamente."));
    }
  }

  Future<void> _onSignInWithPin(
      SignInWithPinEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithPin(event.pin);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("PIN incorrecto"));
      }
    } catch (e) {
      emit(AuthError("Error al iniciar sesión con PIN"));
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
