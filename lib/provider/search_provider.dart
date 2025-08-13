import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant.dart';

import 'result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService});

  ResultState _state = ResultState.noData;
  String _message = 'Cari restoran yang Anda inginkan';
  List<Restaurant> _restaurants = [];

  ResultState get state => _state;
  String get message => _message;
  List<Restaurant> get result => _restaurants;

  Future<void> searchRestaurants(String query) async {
    try {
      if (query.isEmpty) {
        _state = ResultState.noData;
        _message = 'Cari restoran yang Anda inginkan';
        notifyListeners();
        return;
      }

      _state = ResultState.loading;
      notifyListeners();

      final results = await apiService.searchRestaurants(query);
      if (results.isEmpty) {
        _state = ResultState.noData;
        _message = 'Restoran tidak ditemukan';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _restaurants = results;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Pencarian gagal, periksa koneksi Anda.';
      notifyListeners();
    }
  }
}
