import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restoran_detail.dart';

class TestApi {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  static Future<RestaurantDetail> detailRestoran(
      String id, http.Client client) async {
    var response = await client.get(Uri.parse(_baseUrl + "detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error");
    }
  }
}
