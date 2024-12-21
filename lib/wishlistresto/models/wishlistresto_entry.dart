// To parse this JSON data, do
//
//     final wishlistResto = wishlistRestoFromJson(jsonString);

import 'dart:convert';

List<WishlistResto> wishlistRestoFromJson(String str) =>
    List<WishlistResto>.from(
        json.decode(str).map((x) => WishlistResto.fromJson(x)));

String wishlistRestoToJson(List<WishlistResto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishlistResto {
  String model;
  String pk;
  Fields fields;

  WishlistResto({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory WishlistResto.fromJson(Map<String, dynamic> json) => WishlistResto(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String restaurantWanted;
  int user;
  bool wantedResto;
  bool visited;

  Fields({
    required this.restaurantWanted,
    required this.user,
    required this.wantedResto,
    required this.visited,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        restaurantWanted: json["restaurant_wanted"],
        user: json["user"],
        wantedResto: json["wanted_resto"],
        visited: json["visited"],
      );

  Map<String, dynamic> toJson() => {
        "restaurant_wanted": restaurantWanted,
        "user": user,
        "wanted_resto": wantedResto,
        "visited": visited,
      };
}
