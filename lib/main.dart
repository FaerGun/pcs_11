import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pcs_11/pages/basket_page.dart';
import 'package:pcs_11/pages/favourite.dart';
import 'package:pcs_11/pages/login_page.dart';
import 'package:pcs_11/pages/profile.dart';
import 'models/note.dart';
import 'pages/home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const MyHomePage(),
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
  Set<Sweet> favoriteSweets = <Sweet>{};
  Set<Sweet> basketItems = <Sweet>{};
  bool _isLoggedIn = false;
  final List<Sweet> orderHistory = [];


  static const List<Widget> _widgetTitles = [
    Text('Главная'),
    Text('Избранное'),
    Text('Корзина'),
    Text('Профиль'),
    Text('Чат'),
  ];

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();

    _updateWidgetOptions();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _isLoggedIn = user != null;
        _updateWidgetOptions();
      });
    });
  }

  Future<void> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  void _updateWidgetOptions() {
    _widgetOptions = <Widget>[
      HomePage(
        favoriteSweets: favoriteSweets,
        onFavoriteChanged: _onFavoriteChanged,
        onAddToBasket: _addToBasket,
      ),
      FavoritePage(
        favoriteSweets: favoriteSweets,
        onFavoriteChanged: _onFavoriteChanged,
      ),
      BasketPage(
        basketItems: basketItems,
        onRemoveFromBasket: _removeFromBasket,
        onPurchaseComplete: _addOrderToHistory,
      ),
      _isLoggedIn
          ? ProfilePage()
          : const LoginPage(),
    ];
  }

  void _onFavoriteChanged(Sweet sweet, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteSweets.add(sweet);
      } else {
        favoriteSweets.remove(sweet);
      }
    });
  }

  void _addToBasket(Sweet sweet) {
    setState(() {
      basketItems.add(sweet);
    });
  }

  void _addOrderToHistory(List<Sweet> purchasedItems) {
    setState(() {
      orderHistory.addAll(purchasedItems);
    });
  }

  void _removeFromBasket(Sweet sweet) {
    setState(() {
      basketItems.remove(sweet);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чат',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 42, 140, 30),
        unselectedItemColor: const Color.fromARGB(255, 126, 165, 99),
        backgroundColor: const Color.fromARGB(255, 38, 94, 39),
        onTap: (_onItemTapped),
      ),
    );
  }
}
