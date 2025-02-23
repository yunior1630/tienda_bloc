import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl(
      {required this.firebaseAuth, required this.googleSignIn});

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;

    return user != null
        ? UserEntity(
            uid: user.uid, email: user.email, displayName: user.displayName)
        : null;
  }

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) async {
    final UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = userCredential.user;

    return user != null ? UserEntity(uid: user.uid, email: user.email) : null;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
