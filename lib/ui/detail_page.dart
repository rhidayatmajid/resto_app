import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';
import 'package:resto_app/provider/restaurant_detail_provider.dart';
import 'package:resto_app/provider/result_state.dart';

class DetailPage extends StatelessWidget {
  final String restaurantId;

  const DetailPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(apiService: ApiService(), restaurantId: restaurantId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Restoran')),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, _) {
            switch (provider.state) {
              case ResultState.loading:
                return const Center(child: CircularProgressIndicator());
              case ResultState.hasData:
                final restaurant = provider.result;
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

                            // BAGIAN MENU YANG DIKEMBALIKAN
                            Text('Menu Makanan', style: Theme.of(context).textTheme.titleLarge),
                            _buildMenuList(restaurant.menus.foods),
                            const SizedBox(height: 16),
                            Text('Menu Minuman', style: Theme.of(context).textTheme.titleLarge),
                            _buildMenuList(restaurant.menus.drinks),
                            const Divider(height: 32),

                            // BAGIAN REVIEW
                            Text('Reviews', style: Theme.of(context).textTheme.titleLarge),
                            ElevatedButton(
                              child: const Text('Tambah Review'),
                              onPressed: () => _showAddReviewDialog(context, provider),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: restaurant.customerReviews.length,
                              itemBuilder: (context, index) {
                                final review = restaurant.customerReviews.reversed.toList()[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(review.name),
                                    subtitle: Text(review.review),
                                    trailing: Text(
                                      review.date,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              case ResultState.error:
                return Center(child: Text(provider.message));
              default:
                return const Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }

  // WIDGET HELPER UNTUK MEMBANGUN DAFTAR MENU
  Widget _buildMenuList(List<Category> items) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fastfood, size: 50),
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

  // Method untuk menampilkan dialog tambah review
  void _showAddReviewDialog(BuildContext context, RestaurantDetailProvider provider) {
    final nameController = TextEditingController();
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Review Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: 'Review'),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
          actions: [
            TextButton(child: const Text('Batal'), onPressed: () => Navigator.pop(context)),
            ElevatedButton(
              child: const Text('Kirim'),
              onPressed: () {
                // Validasi sederhana agar tidak mengirim review kosong
                if (nameController.text.isNotEmpty && reviewController.text.isNotEmpty) {
                  provider.addReview(nameController.text, reviewController.text);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
