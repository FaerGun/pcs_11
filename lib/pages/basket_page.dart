import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note.dart';
import '../api/api.dart';

class BasketPage extends StatefulWidget {
  final Set<Gear> basketItems;
  final Function(Gear) onRemoveFromBasket;
  final Function(List<Gear>) onPurchaseComplete;

  const BasketPage({
    Key? key,
    required this.basketItems,
    required this.onRemoveFromBasket,
    required this.onPurchaseComplete,
  }) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final ApiService apiService = ApiService();
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isLoggedIn = session != null;
    });
  }

  int getTotalPrice() {
    return widget.basketItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _increaseQuantity(Gear gear) {
    setState(() {
      gear.quantity++;
    });
  }

  void _decreaseQuantity(Gear gear) {
    setState(() {
      if (gear.quantity > 1) {
        gear.quantity--;
      } else {
        widget.onRemoveFromBasket(gear);
      }
    });
  }

  Future<void> _handlePayment() async {
    if (!_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вы должны войти в систему, чтобы оформить заказ.')),
      );
      return;
    }

    if (widget.basketItems.isNotEmpty) {
      final purchasedItems = widget.basketItems.toList();
      final totalCost = getTotalPrice();

      try {
        await apiService.createOrder(purchasedItems, totalCost);

        widget.onPurchaseComplete(purchasedItems);
        setState(() {
          widget.basketItems.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заказ оформлен!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при оформлении заказа: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: widget.basketItems.isEmpty
          ? const Center(child: Text("Ваша корзина пуста"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.basketItems.length,
              itemBuilder: (context, index) {
                final gear = widget.basketItems.elementAt(index);
                return ListTile(
                  leading: Image.network(
                    gear.imageUrl,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(gear.name),
                  subtitle: Text(
                      '${gear.price} рублей x ${gear.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _decreaseQuantity(gear),
                      ),
                      Text(gear.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _increaseQuantity(gear),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Общая сумма: $totalPrice рублей',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: widget.basketItems.isNotEmpty && _isLoggedIn
                      ? _handlePayment
                      : null,
                  child: const Text('Оплатить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}