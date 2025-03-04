import 'package:equatable/equatable.dart';
import 'package:tienda_bloc/features/authentication/domain/entities/user_entity.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated(this.user) {
    print(
        "✅ Estado cambiado a: Authenticated (${user.email})"); // 🔥 Diagnóstico
  }

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  Unauthenticated() {
    print("❌ Estado cambiado a: Unauthenticated"); // 🔥 Diagnóstico
  }
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message) {
    print("🚨 Estado cambiado a: AuthError - $message"); // 🔥 Diagnóstico
  }

  @override
  List<Object?> get props => [message];
}
