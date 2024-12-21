import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(
    json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
  Model model;
  int pk;
  Fields fields;

  ProductEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
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
  Preferensi preferensi;
  String menu;
  String restoran;

  Fields({
    required this.preferensi,
    required this.menu,
    required this.restoran,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        preferensi: preferensiValues.map[json["preferensi"]]!,
        menu: json["menu"],
        restoran: json["restoran"],
      );

  Map<String, dynamic> toJson() => {
        "preferensi": preferensiValues.reverse[preferensi],
        "menu": menu,
        "restoran": restoran,
      };
}

enum Preferensi { CHINESE, INDONESIA, JAPANESE, MIDDLE_EASTERN, WESTERN }

final preferensiValues = EnumValues({
  "Chinese": Preferensi.CHINESE,
  "Indonesia": Preferensi.INDONESIA,
  "Japanese": Preferensi.JAPANESE,
  "Middle Eastern": Preferensi.MIDDLE_EASTERN,
  "Western": Preferensi.WESTERN
});

enum Model { TIPEMAKANAN_MAKANAN }

final modelValues =
    EnumValues({"tipemakanan.makanan": Model.TIPEMAKANAN_MAKANAN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
