import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../pages/login_page.dart';
import '../pages/profile.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.orderHistory});
  final List<Sweet> orderHistory;

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    // Слушаем изменения состояния аутентификации
    _authStateStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator())
          );
        }

        final user = snapshot.data;
        if (user != null) {
          return ProfilePage(); // Переход на профиль, если пользователь аутентифицирован
        } else {
          return const LoginPage(); // Переход на страницу логина, если пользователь не аутентифицирован
        }
      },
    );
  }
}
