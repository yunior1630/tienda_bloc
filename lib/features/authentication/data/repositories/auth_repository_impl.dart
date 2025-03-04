import 'package:tienda_bloc/features/authentication/domain/entities/user_entity.dart';
import 'package:tienda_bloc/features/authentication/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) async {
    return await remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity?> signInWithPin(String pin) async {
    return await remoteDataSource.signInWithPin(pin);
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }
}
