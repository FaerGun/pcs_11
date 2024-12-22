import 'package:cloud_firestore/cloud_firestore.dart';

/// Добавление демо-данных в коллекцию `products`
Future<void> addDemoData() async {
  final products = [
    {
      "id": 1,
      "name": "Удочка профессиональная",
      "description": "Идеально подходит для профессионалов.",
      "imageUrl": "https://wonderfulengineering.com/wp-content/uploads/2016/01/10-Best-Fishing-Rods-9.jpg",
      "price": 1500,
      "isFavorite": false,
    },
    {
      "id": 2,
      "name": "Катушка",
      "description": "Высококачественная катушка для рыбалки.",
      "imageUrl": "https://wonderfulengineering.com/wp-content/uploads/2016/01/10-Best-Fishing-Rods-6.jpg",
      "price": 800,
      "isFavorite": false,
    },
    {
      "id": 3,
      "name": "Приманка универсальная",
      "description": "Отличная приманка для любой рыбалки.",
      "imageUrl": "https://wonderfulengineering.com/wp-content/uploads/2016/01/10-Best-Fishing-Rods-2.jpg",
      "price": 300,
      "isFavorite": false,
    },
    {
      "id": 4,
      "name": "Сетевой поплавок",
      "description": "Лёгкий и прочный поплавок.",
      "imageUrl": "https://wonderfulengineering.com/wp-content/uploads/2016/01/10-Best-Fishing-Rods-7.jpg",
      "price": 500,
      "isFavorite": false,
    },
  ];

  try {
    for (var product in products) {
      // Добавление в Firestore
      await FirebaseFirestore.instance.collection('products').add(product);
    }
    print("Демо-данные успешно добавлены.");
  } catch (e) {
    print("Ошибка при добавлении демо-данных: $e");
  }
}
