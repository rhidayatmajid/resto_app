import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/provider/result_state.dart';
import 'package:resto_app/provider/search_provider.dart';
import 'package:resto_app/ui/detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pencarian')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Masukkan nama restoran...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                Provider.of<SearchProvider>(context, listen: false).searchRestaurants(query);
              },
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                switch (provider.state) {
                  case ResultState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case ResultState.hasData:
                    return ListView.builder(
                      itemCount: provider.result.length,
                      itemBuilder: (context, index) {
                        return CardRestaurant(restaurant: provider.result[index]);
                      },
                    );
                  default:
                    // Menampilkan pesan untuk state NoData dan Error
                    return Center(child: Text(provider.message));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET BARU UNTUK MENAMPILKAN ITEM RESTORAN
class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Hero(
          tag: restaurant.id,
          child: Image.network(
            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
            width: 100,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
          ),
        ),
        title: Text(restaurant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(restaurant.city), Text('Rating: ${restaurant.rating}')],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailPage(restaurantId: restaurant.id);
              },
            ),
          );
        },
      ),
    );
  }
}
