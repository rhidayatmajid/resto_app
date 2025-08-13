import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/restaurant.dart';
import '../model/restaurant_detail.dart'; // Impor model baru

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _listEndpoint = 'list';
  static const String _detailEndpoint = 'detail/';

  Future<List<Restaurant>> getRestaurants() async {
    final response = await http.get(Uri.parse('${_baseUrl}list'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(response.body);
      final List<dynamic> restaurantsJson = parsed['restaurants'];
      return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      // TAMBAHKAN BLOK INI
      throw Exception('Gagal memuat daftar restoran');
    }
  }

  // TAMBAHKAN FUNGSI INI
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('${_baseUrl}search?q=$query'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(response.body);
      final List<dynamic> restaurantsJson = parsed['restaurants'];
      return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Gagal melakukan pencarian');
    }
  }

  // TAMBAHKAN METHOD DI BAWAH INI
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + _detailEndpoint + id));

    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = json.decode(response.body);
      return RestaurantDetail.fromJson(parsed['restaurant']);
    } else {
      throw Exception('Gagal memuat detail restoran');
    }
  }
}
