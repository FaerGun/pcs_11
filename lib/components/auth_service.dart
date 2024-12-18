import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Вход с помощью электронной почты и пароля
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow; // Перехватываем и передаем ошибку выше
    }
  }

  // Регистрация с помощью электронной почты и пароля
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow; // Перехватываем и передаем ошибку выше
    }
  }

  // Выход из системы
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Получение текущего пользователя (если он аутентифицирован)
  String? getCurrentUserEmail() {
    final User? user = _firebaseAuth.currentUser;
    return user?.email;
  }
}
