// To parse this JSON data, do
//
//     final restoEntry = restoEntryFromJson(jsonString);

import 'dart:convert';

List<RestoEntry> restoEntryFromJson(String str) => List<RestoEntry>.from(json.decode(str).map((x) => RestoEntry.fromJson(x)));

String restoEntryToJson(List<RestoEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestoEntry {
    Model model;
    String pk;
    Fields fields;

    RestoEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RestoEntry.fromJson(Map<String, dynamic> json) => RestoEntry(
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
    String nama;
    JenisMakanan jenisMakanan;
    double rating;
    int harga;
    double jarak;
    Suasana suasana;
    int entertainment;
    int keramaian;

    Fields({
        required this.nama,
        required this.jenisMakanan,
        required this.rating,
        required this.harga,
        required this.jarak,
        required this.suasana,
        required this.entertainment,
        required this.keramaian,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        nama: json["nama"],
        jenisMakanan: jenisMakananValues.map[json["jenis_makanan"]]!,
        rating: json["rating"]?.toDouble(),
        harga: json["harga"],
        jarak: json["jarak"]?.toDouble(),
        suasana: suasanaValues.map[json["suasana"]]!,
        entertainment: json["entertainment"],
        keramaian: json["keramaian"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
        "jenis_makanan": jenisMakananValues.reverse[jenisMakanan],
        "rating": rating,
        "harga": harga,
        "jarak": jarak,
        "suasana": suasanaValues.reverse[suasana],
        "entertainment": entertainment,
        "keramaian": keramaian,
    };
}

enum JenisMakanan {
    CHINESE,
    INDONESIA,
    JAPANESE,
    MIDDLE_EASTERN,
    WESTERN
}

final jenisMakananValues = EnumValues({
    "Chinese": JenisMakanan.CHINESE,
    "Indonesia": JenisMakanan.INDONESIA,
    "Japanese": JenisMakanan.JAPANESE,
    "Middle Eastern": JenisMakanan.MIDDLE_EASTERN,
    "Western": JenisMakanan.WESTERN
});

enum Suasana {
    FORMAL,
    SANTAI
}

final suasanaValues = EnumValues({
    "Formal": Suasana.FORMAL,
    "Santai": Suasana.SANTAI
});

enum Model {
    SEARCH_RESTAURANT
}

final modelValues = EnumValues({
    "search.restaurant": Model.SEARCH_RESTAURANT
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
