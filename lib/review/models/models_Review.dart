// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    String pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    int user;
    String restaurant;
    String review;
    DateTime datePosted;

    Fields({
        required this.user,
        required this.restaurant,
        required this.review,
        required this.datePosted,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        restaurant: json["restaurant"],
        review: json["review"],
        datePosted: DateTime.parse(json["date_posted"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "restaurant": restaurant,
        "review": review,
        "date_posted": datePosted.toIso8601String(),
    };
}
