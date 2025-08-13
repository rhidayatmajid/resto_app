import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/model/restaurant_detail.dart';

class DetailPage extends StatefulWidget {
  final String restaurantId;

  const DetailPage({super.key, required this.restaurantId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<RestaurantDetail> _restaurantDetail;

  @override
  void initState() {
    super.initState();
    _restaurantDetail = ApiService().getRestaurantDetail(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Restoran')),
      body: FutureBuilder<RestaurantDetail>(
        future: _restaurantDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final restaurant = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: restaurant.id,
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurant.name, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Text(restaurant.city),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(restaurant.rating.toString()),
                          ],
                        ),
                        const Divider(height: 32),
                        Text('Deskripsi', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(restaurant.description),
                        const Divider(height: 32),
                        Text('Menu Makanan', style: Theme.of(context).textTheme.titleLarge),
                        _buildMenuList(restaurant.menus.foods),
                        const SizedBox(height: 16),
                        Text('Menu Minuman', style: Theme.of(context).textTheme.titleLarge),
                        _buildMenuList(restaurant.menus.drinks),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }

  Widget _buildMenuList(List<Category> items) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Icon(Icons.fastfood, size: 50), // Ganti dengan ikon yang sesuai
                  const SizedBox(height: 8),
                  Text(items[index].name),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
