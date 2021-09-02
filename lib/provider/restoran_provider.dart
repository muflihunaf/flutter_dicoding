import 'package:flutter/widgets.dart';
import 'package:restaurant_app/common/database_helper.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:restaurant_app/data/model/restoran.dart' as restoran;
import 'package:restaurant_app/data/model/restoran_detail.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart' as search;
import 'package:shared_preferences/shared_preferences.dart';

enum ResultState { Loading, NoData, HasData, Error, Found, NotFound, Done }

class RestoranProvider extends ChangeNotifier {
  final ApiService apiService;

  restoran.Restaurant? _restaurantList;
  late String _message = '';
  late ResultState _state;

  String get message => _message;
  ResultState get state => _state;
  restoran.Restaurant? get result => _restaurantList;

  RestaurantDetail? _restaurantDetail;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;

  search.RestaurantResult? _search;
  search.RestaurantResult? get resultSearch => _search;

  List<Favorite> _favorite = [];
  late DatabaseHelper _databaseHelper;

  List<String>? _favor = [];
  List<String>? get favor => _favor;

  SharedPreferences? _isFavorite;
  SharedPreferences? get isFavorite => _isFavorite;

  List<Favorite> get favorite => _favorite;

  void _getFavorite() async {
    _isFavorite = await SharedPreferences.getInstance();
    _favor = _isFavorite!.getStringList('favorite') ?? [];
    print(_favor);
    _favorite = await _databaseHelper.getFavorite();
    notifyListeners();
  }

  RestoranProvider({required this.apiService}) {
    _databaseHelper = DatabaseHelper();
    fetchAllRestaurant();
    _getFavorite();
  }

  Future<void> addFavorite(Favorite restaurantElement) async {
    await _databaseHelper.insertFavorite(restaurantElement);
    _favor!.add(restaurantElement.id.toString());
    _isFavorite!.setStringList('favorite', _favor!);
    _getFavorite();
  }

  Future<void> deleteFavorite(String delete) async {
    await _databaseHelper.deleteFavorite(delete);
    _favor!.remove(delete);
    _isFavorite!.setStringList('favorite', _favor!);

    _getFavorite();
  }

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.fetchRestaurant();
      if (restaurant.error == true) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantList = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = '$e';
    }
  }

  Future<dynamic> fetchADetailRestaurant(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurantDetail = await apiService.fetchDetailRestaurant(id);
      if (restaurantDetail.error == true) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantDetail = restaurantDetail;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = '$e';
    }
  }

  Future<dynamic> searchRestaurant(String key) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(key);
      if (restaurant.founded == 0) {
        _state = ResultState.NotFound;
        notifyListeners();
        return _message = 'Tidak Ada Data';
      } else {
        _state = ResultState.Found;
        notifyListeners();
        return _search = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
