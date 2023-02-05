import 'dart:convert';
import '/data/model/restaurant_detail.dart';

class CustomerReviewModel {
  CustomerReviewModel({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  bool error;
  String message;
  List<CustomerReview> customerReviews;

  factory CustomerReviewModel.fromRawJson(String str) =>
      CustomerReviewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) =>
      CustomerReviewModel(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}
