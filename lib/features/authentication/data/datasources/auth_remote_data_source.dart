import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> signInWithPin(String pin);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });

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
  Future<UserEntity?> signInWithPin(String pin) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('pin', isEqualTo: pin)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ PIN incorrecto o no registrado en Firestore.");
        return null;
      }

      final userDoc = querySnapshot.docs.first;
      final String uid = userDoc.id; // 🔥 UID basado en Firestore
      final String email = userDoc['email'] ?? 'sin-email';
      final String displayName = userDoc['displayName'] ?? 'Usuario PIN';

      print(
          "✅ Usuario PIN encontrado con UID: $uid, autenticando en Firebase Auth...");

      // 🔹 Crear usuario con UID en Firebase Auth
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        print("❌ Error: No se pudo autenticar al usuario con PIN.");
        return null;
      }

      return UserEntity(
        uid: firebaseUser.uid,
        email: email,
        displayName: displayName,
      );
    } catch (e) {
      print("🚨 Error al autenticar con PIN: $e");
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
