import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/provider/restaurant_provider.dart';
import 'package:resto_app/provider/result_state.dart';
import 'package:resto_app/provider/theme_provider.dart';
import 'package:resto_app/ui/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Widget untuk membangun daftar restoran
  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.loading:
            return const Center(child: CircularProgressIndicator());
          case ResultState.hasData:
            return ListView.builder(
              itemCount: provider.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = provider.restaurants[index];
                // Menggunakan widget CardRestaurant yang diimpor dari search_page.dart
                return CardRestaurant(restaurant: restaurant);
              },
            );
          case ResultState.noData:
            return Center(child: Text(provider.message));
          case ResultState.error:
            return Center(child: Text(provider.message));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
            },
          ),
          Switch.adaptive(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
            },
          ),
        ],
      ),
      body: _buildList(context),
    );
  }
}
