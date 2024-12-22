import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/note.dart';
import 'pages/home_page.dart';
import 'pages/favourite.dart';
import 'pages/basket_page.dart';
import 'pages/login_page.dart';
import 'pages/profile.dart';
import 'pages/chat_list_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Все для улова от рыболова',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const MyHomePage(); // Пользователь авторизован
        } else {
          return const LoginPage(); // Пользователь не авторизован
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final Set<Sweet> _favoriteSweets = {};
  final Set<Sweet> _basketItems = {};

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    _pages.addAll([
      HomePage(
        favoriteSweets: _favoriteSweets,
        onFavoriteChanged: _onFavoriteChanged,
        onAddToBasket: _addToBasket,
      ),
      FavoritePage(
        favoriteSweets: _favoriteSweets,
        onFavoriteChanged: _onFavoriteChanged,
      ),
      BasketPage(
        basketItems: _basketItems,
        onRemoveFromBasket: _removeFromBasket,
        onPurchaseComplete: _clearBasket,
      ),
      ProfilePage(onSignOut: _signOut),
      if (currentUserUid == "seller_specific_uid") // Проверьте UID продавца
        ChatListPage(sellerUid: currentUserUid!),
    ]);
  }

  void _onFavoriteChanged(Sweet sweet, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        _favoriteSweets.add(sweet);
      } else {
        _favoriteSweets.remove(sweet);
      }
    });
  }

  void _addToBasket(Sweet sweet) {
    setState(() {
      _basketItems.add(sweet);
    });
  }

  void _removeFromBasket(Sweet sweet) {
    setState(() {
      _basketItems.remove(sweet);
    });
  }

  void _clearBasket(List<Sweet> purchasedItems) {
    setState(() {
      _basketItems.clear();
    });
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSeller = FirebaseAuth.instance.currentUser?.uid == "seller_specific_uid";
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
      const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
      const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
    ];
    if (isSeller) {
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чаты'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text([
          'Главная',
          'Избранное',
          'Корзина',
          'Профиль',
          if (isSeller) 'Чаты'
        ][_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
