// To parse this JSON data, do
//
//     final restor = restorFromJson(jsonString);

import 'dart:convert';

List<Restor> restorFromJson(String str) => List<Restor>.from(json.decode(str).map((x) => Restor.fromJson(x)));

String restorToJson(List<Restor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Restor {
    Model model;
    String pk;
    Fields fields;

    Restor({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Restor.fromJson(Map<String, dynamic> json) => Restor(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String restaurant;
    double rating;

    Fields({
        required this.restaurant,
        required this.rating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        restaurant: json["restaurant"],
        rating: json["rating"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "restaurant": restaurant,
        "rating": rating,
    };
}

enum Model {
    REVIEW_RESTOR
}

final modelValues = EnumValues({
    "review.restor": Model.REVIEW_RESTOR
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
