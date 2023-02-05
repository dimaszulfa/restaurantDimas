import 'dart:convert';
import '/data/model/restaurant.dart';

class RestaurantSearchModel {
  RestaurantSearchModel({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool? error;
  int? founded;
  List<Restaurant?>? restaurants;

  factory RestaurantSearchModel.fromRawJson(String str) =>
      RestaurantSearchModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantSearchModel.fromJson(Map<String, dynamic> json) =>
      RestaurantSearchModel(
        error: json["error"],
        founded: json["founded"],
        restaurants: json["restaurants"] == null
            ? []
            : List<Restaurant?>.from(
                json["restaurants"]!.map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": restaurants == null
            ? []
            : List<dynamic>.from(restaurants!.map((x) => x!.toJson())),
      };
}
