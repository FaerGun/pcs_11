import 'package:flutter/material.dart';
import '../components/item_note.dart';
import '../models/note.dart';

class FavoritePage extends StatefulWidget {
  final Set<Gear> favoriteGears;
  final Function(Gear, bool) onFavoriteChanged;

  const FavoritePage({
    super.key,
    required this.favoriteGears,
    required this.onFavoriteChanged,
  });

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Избранное',
        ),
        centerTitle: true,
      ),
      body: widget.favoriteGears.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 80,
            ),
            SizedBox(height: 16),
            Text(
              'У вас нет избранных товаров',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: widget.favoriteGears.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 2 / 3,
          ),
          itemBuilder: (context, index) {
            final gear = widget.favoriteGears.elementAt(index);
            return GestureDetector(
              onTap: () {
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            child: Image.network(
                              gear.imageUrl,
                              fit: BoxFit.cover,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
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
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () {
                          widget.onFavoriteChanged(gear, false);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}