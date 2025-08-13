import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Impor menggunakan path relatif yang benar
import 'common/styles.dart';
import 'data/api/api_service.dart';
import 'provider/restaurant_provider.dart';
import 'provider/search_provider.dart';
import 'provider/theme_provider.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MultiProvider untuk mendaftarkan semua provider
    return MultiProvider(
      providers: [
        // Provider untuk manajemen tema (terang/gelap)
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Provider untuk mengambil daftar restoran utama
        ChangeNotifierProvider(create: (_) => RestaurantProvider(apiService: ApiService())),

        // Provider untuk fitur pencarian restoran
        ChangeNotifierProvider(create: (_) => SearchProvider(apiService: ApiService())),
      ],
      // Menggunakan Consumer untuk menerapkan perubahan tema
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: provider.isDarkMode ? darkTheme : lightTheme,
            home: const HomePage(),
            debugShowCheckedModeBanner: false, // Menghilangkan banner debug
          );
        },
      ),
    );
  }
}
