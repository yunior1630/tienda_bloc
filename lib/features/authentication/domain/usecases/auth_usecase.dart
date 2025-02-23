import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.signInWithGoogle();
  }
}

class SignInWithEmailUseCase {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    return await repository.signInWithEmail(email, password);
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
