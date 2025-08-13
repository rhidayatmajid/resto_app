import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant.dart';

import 'result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    // Langsung panggil method untuk mengambil data saat provider dibuat
    _fetchAllRestaurants();
  }

  // Variabel privat untuk menyimpan data dan state
  late List<Restaurant> _restaurants;
  late ResultState _state;
  String _message = '';

  // Getter untuk diakses oleh UI
  List<Restaurant> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  // Method untuk mengambil data dari API
  Future<void> _fetchAllRestaurants() async {
    try {
      // Set state ke loading dan beri tahu UI
      _state = ResultState.loading;
      notifyListeners();

      // Panggil API
      final result = await apiService.getRestaurants();

      if (result.isEmpty) {
        // Jika data kosong, set state ke NoData
        _state = ResultState.noData;
        _message = 'Data Restoran Kosong';
        notifyListeners();
      } else {
        // Jika data ada, set state ke HasData
        _state = ResultState.hasData;
        _restaurants = result;
        notifyListeners();
      }
    } catch (e) {
      // Jika terjadi error, set state ke Error
      _state = ResultState.error;
      _message = 'Gagal memuat data. Periksa koneksi internet Anda.';
      notifyListeners();
    }
  }
}
