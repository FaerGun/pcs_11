import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword(String email,
      String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception('Ошибка входа: ${e.message}');
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email,
      String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception('Ошибка регистрации: ${e.message}');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? getCurrentUserEmail() {
    final User? user = _firebaseAuth.currentUser;
    return user?.email;
  }

  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  String? getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}