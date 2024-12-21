// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String id;
    User user;
    String restaurant;
    String review;
    DateTime datePosted;

    Review({
        required this.id,
        required this.user,
        required this.restaurant,
        required this.review,
        required this.datePosted,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        user: User.fromJson(json["user"]),
        restaurant: json["restaurant"],
        review: json["review"],
        datePosted: DateTime.parse(json["date_posted"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "restaurant": restaurant,
        "review": review,
        "date_posted": datePosted.toIso8601String(),
    };
}

class User {
    int id;
    String username;

    User({
        required this.id,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
    };
}
