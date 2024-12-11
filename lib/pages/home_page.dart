import 'package:flutter/material.dart';
import '../models/note.dart';
import '../components/item_note.dart';
import '../api/api.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  final Set<Gear> favoriteGears;
  final Function(Gear, bool) onFavoriteChanged;
  final Function(Gear) onAddToBasket;

  const HomePage({
    Key? key,
    required this.favoriteGears,
    required this.onFavoriteChanged,
    required this.onAddToBasket,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  List<Gear> gears = [];
  List<Gear> filteredGears = [];

  final TextEditingController searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _flavorController = TextEditingController();



  String filterType = 'Все';
  bool isDescending = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await apiService.getProducts();
      setState(() {
        gears = products;
        filteredGears = List.from(gears);
      });
    } catch (e) {
      print("Ошибка при загрузке продуктов: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  Future<void> _deleteProduct(Gear gear) async {
    try {
      await apiService.deleteProduct(gear.id);
      await fetchProducts();
    } catch (e) {
      print("Ошибка при удалении продукта: $e");
    }
  }

  void _toggleFavorite(Gear gear) {
    final isFavorite = widget.favoriteGears.contains(gear);
    widget.onFavoriteChanged(gear, !isFavorite);
  }

  Future<void> _addNewGear() async {
    final newGear = Gear(
      id: 0,
      name: _nameController.text,
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
      price: int.tryParse(_priceController.text) ?? 0,
      brand: _brandController.text,
      flavor: _flavorController.text,

      isFavorite: false,
    );

    try {
      await apiService.createProduct(newGear);
      await fetchProducts();
    } catch (e) {
      print("Ошибка при добавлении продукта: $e");
    }

    _nameController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    _brandController.clear();
    _flavorController.clear();

  }

  void _showAddGearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить новый товар'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                      labelText: 'URL изображения'),
                ),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Цена'),
                ),
                TextField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Бренд'),
                ),



              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addNewGear();
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _updateFilteredProducts() {
    List<Gear> tempGears = List.from(gears);

    if (filterType == 'Цена') {
      tempGears.sort((a, b) =>
      isDescending
          ? b.price.compareTo(a.price)
          : a.price.compareTo(b.price));
    } else if (filterType == 'Название') {
      tempGears.sort((a, b) =>
      isDescending
          ? b.name.toLowerCase().compareTo(a.name.toLowerCase())
          : a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      tempGears = tempGears
          .where((gear) => gear.name.toLowerCase().contains(query))
          .toList();
    }

    setState(() {
      filteredGears = tempGears;
    });
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Фильтр товаров'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: filterType,
                    isExpanded: true,
                    items: ['Все', 'Цена', 'Название'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        filterType = newValue!;
                        if (filterType != 'Цена') {
                          isDescending = false;
                        }
                        _updateFilteredProducts();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (filterType == 'Цена')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('По убыванию'),
                        Switch(
                          value: isDescending,
                          onChanged: (value) {
                            setState(() {
                              isDescending = value;
                              _updateFilteredProducts();
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все для улова от рыболова'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => _updateFilteredProducts(),
              decoration: InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredGears.isEmpty
                ? const Center(
              child: Text(
                'Нет доступных товаров',
                style: TextStyle(fontSize: 18),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: filteredGears.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                final gear = filteredGears[index];
                final isFavorite =
                widget.favoriteGears.contains(gear);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          gear: gear,
                          onDelete: () async {
                            await _deleteProduct(gear);
                            await fetchProducts();
                          },
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              gear.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gear.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${gear.price} ₽',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.pinkAccent.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                _toggleFavorite(gear);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.shopping_cart),
                              color: Colors.blueGrey,
                              onPressed: () {
                                widget.onAddToBasket(gear);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${gear.name} добавлен в корзину'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGearDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}