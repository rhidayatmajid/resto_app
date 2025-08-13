import 'package:flutter/material.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/model/restaurant_detail.dart';

import 'result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  RestaurantDetailProvider({required this.apiService, required this.restaurantId}) {
    _fetchDetail(restaurantId);
  }

  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  RestaurantDetail get result => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  Future<void> addReview(String name, String review) async {
    try {
      await apiService.postReview(id: restaurantId, name: name, review: review);
      _fetchDetail(restaurantId);
    } catch (e) {
      print('Error: Gagal menambahkan review. $e');
    }
  }

  Future<void> _fetchDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detail = await apiService.getRestaurantDetail(id);
      _state = ResultState.hasData;
      _restaurantDetail = detail;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal memuat detail. Periksa koneksi Anda.';
      notifyListeners();
    }
  }
}
