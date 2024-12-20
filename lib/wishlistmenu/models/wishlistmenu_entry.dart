// To parse this JSON data, do
//
//     final wishlistMenu = wishlistMenuFromJson(jsonString);

import 'dart:convert';

List<WishlistMenu> wishlistMenuFromJson(String str) => List<WishlistMenu>.from(json.decode(str).map((x) => WishlistMenu.fromJson(x)));

String wishlistMenuToJson(List<WishlistMenu> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishlistMenu {
    String model;
    String pk;
    Fields fields;

    WishlistMenu({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory WishlistMenu.fromJson(Map<String, dynamic> json) => WishlistMenu(
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
    String menuWanted;
    String restaurant;
    int user;
    bool wantedMenu;
    bool tried;

    Fields({
        required this.menuWanted,
        required this.restaurant,
        required this.user,
        required this.wantedMenu,
        required this.tried,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        menuWanted: json["menu_wanted"],
        restaurant: json["restaurant"],
        user: json["user"],
        wantedMenu: json["wanted_menu"],
        tried: json["tried"],
    );

    Map<String, dynamic> toJson() => {
        "menu_wanted": menuWanted,
        "restaurant": restaurant,
        "user": user,
        "wanted_menu": wantedMenu,
        "tried": tried,
    };
}
