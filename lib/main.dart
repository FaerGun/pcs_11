import 'package:pcs_11/pages/basket_page.dart';
import 'package:pcs_11/pages/favourite.dart';
import 'package:pcs_11/pages/login_page.dart';
import 'package:pcs_11/pages/profile.dart';
import 'package:flutter/material.dart';
import 'models/note.dart';
import 'pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(url: 'https://vrhfozwtxyswupwupppl.supabase.co' , anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyaGZvend0eHlzd3Vwd3VwcHBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI1MzEyNzksImV4cCI6MjA0ODEwNzI3OX0.AKGRL2vGlbSrJEqB9oOVcFSCJnosF72IFbkKl7UvmdU');
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
  Set<Gear> favoriteGears = <Gear>{};
  Set<Gear> basketItems = <Gear>{};
  bool _isLoggedIn = false;
  final List<Gear> orderHistory = [];

  static const List<Widget> _widgetTitles = [
    Text('Главная'),
    Text('Избранное'),
    Text('Корзина'),
    Text('Профиль'),
  ];

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();

    _updateWidgetOptions();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      setState(() {
        _isLoggedIn = session != null;
        _updateWidgetOptions();
      });
    });
  }

  Future<void> _checkAuthStatus() async {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isLoggedIn = session != null;
    });
  }

  void _updateWidgetOptions() {
    _widgetOptions = <Widget>[
      HomePage(
        favoriteGears: favoriteGears,
        onFavoriteChanged: _onFavoriteChanged,
        onAddToBasket: _addToBasket,
      ),
      FavoritePage(
        favoriteGears: favoriteGears,
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

  void _onFavoriteChanged(Gear gear, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteGears.add(gear);
      } else {
        favoriteGears.remove(gear);
      }
    });
  }

  void _addToBasket(Gear gear) {
    setState(() {
      basketItems.add(gear);
    });
  }

  void _addOrderToHistory(List<Gear> purchasedItems) {
    setState(() {
      orderHistory.addAll(purchasedItems);
    });
  }

  void _removeFromBasket(Gear gear) {
    setState(() {
      basketItems.remove(gear);
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 32, 100, 156),
        unselectedItemColor: const Color.fromARGB(255, 32, 100, 156),
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}