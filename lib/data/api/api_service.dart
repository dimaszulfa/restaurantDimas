import 'dart:convert';
import 'package:http/http.dart' as http;
import '/data/model/customer_review.dart';
import '/data/model/restaurant.dart';
import '/data/model/restaurant_detail.dart';
import '/data/model/restaurant_search.dart';
import '/util/enums.dart';

class ApiServiceHttpClient {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _getListRestaurant = "$_baseUrl/list";
  static const String _getDetailRestaurant = "$_baseUrl/detail";
  static const String _getPicture = "$_baseUrl/images";
  static const String _getSearch = "$_baseUrl/search";
  static const String _postReview = "$_baseUrl/review";

  Future<RestaurantModel> listRestaurant() async {
    final response = await http.get(Uri.parse(_getListRestaurant));
    if (response.statusCode == 200) {
      return RestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("${response.statusCode} ${response.body}");
    }
  }

  Future<RestaurantDetailModel> detailRestaurant(String id) async {
    String url = "$_getDetailRestaurant/$id";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("${response.statusCode} ${response.body}");
    }
  }

  String picture(String pictureId, PictureSize pictureSize) {
    switch (pictureSize) {
      case PictureSize.small:
        return "$_getPicture/small/$pictureId";
      case PictureSize.medium:
        return "$_getPicture/medium/$pictureId";
      case PictureSize.big:
        return "$_getPicture/big/$pictureId";
    }
  }

  Future<RestaurantSearchModel> searchRestaurant(String query) async {
    String url = "$_getSearch?q=$query";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantSearchModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("${response.statusCode} ${response.body}");
    }
  }

  Future<CustomerReviewModel> addReview(
      String id, String name, String review) async {
    String url = _postReview;
    Map data = {'id': id, 'name': name, 'review': review};
    var body = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 201) {
      return CustomerReviewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("${response.statusCode} ${response.body}");
    }
  }
}
