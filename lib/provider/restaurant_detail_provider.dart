import 'dart:io';
import 'package:flutter/material.dart';
import '/data/api/api_service.dart';
import '/data/model/customer_review.dart';
import '/data/model/restaurant_detail.dart';
import '/util/enums.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiServiceHttpClient api = ApiServiceHttpClient();

  late RestaurantDetailModel _RestaurantDetailModel;
  late CustomerReviewModel _CustomerReviewModel;
  ResultState? _state;
  String _message = '';

  String get message => _message;
  RestaurantDetailModel get result => _RestaurantDetailModel;
  CustomerReviewModel get resultReview => _CustomerReviewModel;
  ResultState? get state => _state;

  RestaurantDetailProvider getDetailRestaurant(String restaurantId) {
    _fetchDetailRestaurant(restaurantId);
    return this;
  }

  Future<dynamic> _fetchDetailRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurantDetail = await api.detailRestaurant(id);

      if (restaurantDetail.restaurant == null) {
        _state = ResultState.noData;
        notifyListeners();

        return _message = "Empty Data";
      } else {
        _state = ResultState.hasData;
        notifyListeners();

        return _RestaurantDetailModel = restaurantDetail;
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

  Future<dynamic> addReview(String id, String name, String review) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final customerReview = await api.addReview(id, name, review);

      if (customerReview.customerReviews.isNotEmpty) {
        return _message = "Review Added";
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
}
