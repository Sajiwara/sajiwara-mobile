import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Menu {
  final String menu;

  Menu({required this.menu});

  factory Menu.fromJson(dynamic json) {
    if (json is String) {
      return Menu(menu: json);
    }
    return Menu(menu: json['menu'] ?? json['name']);
  }
}

class Restaurant {
  final String name;
  final int id;
  final List<String> menus;

  Restaurant({
    required this.name,
    required this.id,
    this.menus = const [],
  });

  String get shortName {
    if (name.length > 40) {
      return '${name.substring(0, 40)}...';
    }
    return name;
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      id: json['id'],
      menus: json['menus'] != null ? List<String>.from(json['menus']) : [],
    );
  }
}

class WishlistMenuApi {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<List<Menu>> getMenus() async {
    try {
      print('Trying to connect to: http://127.0.0.1:8000/wishlistmenu/api/menus');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/wishlistmenu/menus'),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          List<dynamic> menusJson = json.decode(response.body);
          return menusJson.map((item) => Menu.fromJson(item)).toList();
        } catch (e) {
          print('Error parsing JSON: $e');
          print('Response body was: ${response.body}');
          throw Exception('Invalid response format');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['error'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching menus: $e');
      throw Exception('Failed to load menus: $e');
    }
  }

  static Future<List<Restaurant>> getRestaurants(String menuName) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/wishlistmenu/api/restaurants?menu=$menuName'),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          List<dynamic> restaurantsJson = data['restaurants'];
          return restaurantsJson
              .map((json) => Restaurant.fromJson(json))
              .toList();
        } catch (e) {
          print('Error parsing JSON: $e');
          print('Response body was: ${response.body}');
          throw Exception('Invalid response format');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['error'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      throw Exception('Failed to load restaurants: $e');
    }
  }

  static Future<void> addToWishlist(String menu, int restaurantId) async {
    try {
      final uri = Uri.parse('http://127.0.0.1:8000/wishlistmenu/api/add-to-wishlist/');

      final body = json.encode({
        'menu': menu,
        'restaurant': restaurantId,
      });

      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionid');

      if (sessionId == null) {
        throw Exception('Silakan login terlebih dahulu');
      }


      final response = await http.post(
        uri,
        headers: {
          'Content-Type':
              'application/json',
          'Cookie':
              'sessionid=$sessionId', 
        },
        body: body, 
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 401) {
        throw Exception('Silakan login terlebih dahulu');
      } else if (response.statusCode != 200) {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
              errorData['message'] ?? 'Gagal menambahkan ke wishlist');
        } catch (e) {
          throw Exception('Gagal menambahkan ke wishlist: ${response.body}');
        }
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
      throw Exception(e.toString());
    }
  }
}

class WishlistMenuItem {
  final String id; 
  final String menuName;
  final String restaurantName;
  final bool tried;

  WishlistMenuItem({
    required this.id,
    required this.menuName,
    required this.restaurantName,
    required this.tried,
  });

  factory WishlistMenuItem.fromJson(Map<String, dynamic> json) {
    return WishlistMenuItem(
      id: json['id'], 
      menuName: json['menu_name'],
      restaurantName: json['restaurant_name'],
      tried: json['tried'] ??
          false, 
    );
  }

  static Future<void> updateTriedStatus(String menuId, bool triedStatus) async {
    try {
      final uri = Uri.parse(
          'http://127.0.0.1:8000/wishlistmenu/api/update-tried/$menuId/');

      final body = json.encode({
        'tried': triedStatus,
      });

      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionid');

      if (sessionId == null) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'sessionid=$sessionId',
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update tried status');
      }
    } catch (e) {
      print('Error updating tried status: $e');
      throw Exception('Failed to update tried status');
    }
  }

  static Future<void> deleteWishlistItem(String menuId) async {
    try {
      final uri = Uri.parse(
          'http://127.0.0.1:8000/wishlistmenu/api/delete-wishlist/$menuId/');

      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionid');

      if (sessionId == null) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'sessionid=$sessionId',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete wishlist item');
      }
    } catch (e) {
      print('Error deleting wishlist item: $e');
      throw Exception('Failed to delete wishlist item');
    }
  }
}

Future<List<WishlistMenuItem>> fetchWishlistMenus() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId =
        prefs.getString('sessionid'); 

    if (sessionId == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    final uri = Uri.parse('http://127.0.0.1:8000/wishlistmenu/api/wishlist/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'sessionid=$sessionId', 
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body); 
      List<dynamic> wishlistData =
          data['wishlist_menus']; 
      return wishlistData
          .map((item) => WishlistMenuItem.fromJson(item))
          .toList();
    } else {
      print("Error fetching wishlist menus: ${response.body}");
      throw Exception('Failed to load wishlist menus');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to load wishlist menus');
  }
}

Future<List<WishlistMenuItem>> fetchTriedWishlistMenus() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId =
        prefs.getString('sessionid'); 

    if (sessionId == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    final uri = Uri.parse('http://127.0.0.1:8000/wishlistmenu/api/tried/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'sessionid=$sessionId', 
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> wishlistData =
          data['tried_menus']; 
      List<dynamic> triedData =
          wishlistData.where((item) => item['tried'] == true).toList();

      return triedData.map((item) => WishlistMenuItem.fromJson(item)).toList();
    } else {
      print("Error fetching wishlist menus: ${response.body}");
      throw Exception('Failed to load wishlist menus');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to load wishlist menus');
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
