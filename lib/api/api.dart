import 'package:dio/dio.dart';
import '../models/note.dart';
import '../models/order.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  Future<List<Gear>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      List<Gear> products = (response.data as List)
          .map((json) => Gear.fromJson(json))
          .toList();
      return products;
    } catch (e) {
      throw Exception('Не удалось загрузить продукты: $e');
    }
  }

  Future<void> createProduct(Gear gear) async {
    try {
      await _dio.post('/products', data: gear.toJson());
    } catch (e) {
      throw Exception('Не удалось создать продукт: $e');
    }
  }

  Future<Gear> getProductByID(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Gear.fromJson(response.data);
    } catch (e) {
      throw Exception('Продукт не найден: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Не удалось удалить продукт: $e');
    }
  }


  Future<List<Order>> getOrderHistory() async {
    try {
      final response = await _dio.get('/orders');
      List<Order> orders = (response.data as List)
          .map((json) => Order.fromJson(json))
          .toList();
      return orders;
    } catch (e) {
      throw Exception('Не удалось загрузить историю заказов: $e');
    }
  }

  Future<void> createOrder(List<Gear> orderItems, int totalCost) async {
    try {
      final data = {
        "products": orderItems
            .map((gear) =>
        {
          "product_id": gear.id,
          "name": gear.name,
          "price": gear.price,
          "quantity": gear.quantity,
          "image_url": gear.imageUrl,
        })
            .toList(),
        "total_price": totalCost,
      };

      await _dio.post('/orders', data: data);
    } catch (e) {
      throw Exception('Не удалось отправить заказ: $e');
    }
  }
}