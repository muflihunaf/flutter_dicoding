import 'dart:convert';
import 'dart:io';

import 'package:restaurant_app/data/model/restoran.dart' as restoran;
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restoran_detail.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart' as search;

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<restoran.Restaurant> fetchRestaurant() async {
    try {
      final response = await http
          .get(Uri.parse("$_baseUrl/list"))
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        return restoran.Restaurant.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load top headlines');
      }
    } on SocketException {
      print("Tidak Ada Koneksi Internet");
      throw ('Tidak Ada Koneksi Internet');
    }
  }

  Future<RestaurantDetail> fetchDetailRestaurant(String id) async {
    try {
      final response = await http
          .get(Uri.parse("$_baseUrl/detail/$id"))
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        return RestaurantDetail.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load top headlines');
      }
    } on SocketException {
      throw ('Tidak Ada Koneksi Internet');
    }
  }

  Future<search.RestaurantResult> searchRestaurant(String key) async {
    try {
      final response = await http
          .get(Uri.parse("$_baseUrl/search?q=$key"))
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        return search.RestaurantResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load top headlines');
      }
    } on SocketException {
      print("Tidak Ada Koneksi Internet");
      throw ('Tidak Ada Koneksi Internet');
    }
  }
}
