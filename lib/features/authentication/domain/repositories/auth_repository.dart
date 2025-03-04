import 'package:tienda_bloc/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> signInWithPin(String pin);
  Future<void> signOut();
}
