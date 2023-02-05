import 'dart:io';

import 'package:flutter/material.dart';
import '/data/api/api_service.dart';
import '/data/model/restaurant.dart';
import '/util/enums.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiServiceHttpClient api;

  RestaurantProvider({required this.api}) {
    fetchAllRestaurant();
  }

  late List<Restaurant?>? _restaurants;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  List<Restaurant?>? get result => _restaurants;

  ResultState get state => _state;

  Future<dynamic> fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final RestaurantModel = await api.listRestaurant();
      if (RestaurantModel.restaurants?.isEmpty == true) {
        _state = ResultState.noData;
        notifyListeners();

        return _message = "Empty Data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();

        return _restaurants = RestaurantModel.restaurants;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();

      return _message = "Error --> No Internet Connection";
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = "Error --> $e";
    }
  }

  Future<dynamic> searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final RestaurantSearchModel = await api.searchRestaurant(query);

      if (RestaurantSearchModel.restaurants?.isEmpty ?? false) {
        _state = ResultState.noData;
        notifyListeners();

        return _message = "Data is empty!";
      } else {
        _state = ResultState.hasData;
        notifyListeners();

        return _restaurants = RestaurantSearchModel.restaurants;
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();

      return _message = "Error --> There is no connection found here";
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      return _message = "Error --> $e";
    }
  }
}
