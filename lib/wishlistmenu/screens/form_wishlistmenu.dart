import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WishlistMenuFormPage extends StatefulWidget {
  const WishlistMenuFormPage({super.key});

  @override
  State<WishlistMenuFormPage> createState() => _WishlistMenuFormPageState();
}

class _WishlistMenuFormPageState extends State<WishlistMenuFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedMenu;
  String? _selectedRestaurant;
  List<String> _menus = [];
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/wishlistmenu/menus/'),
      );

      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _menus = List<String>.from(data);
      });
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = jsonDecode(response.body);
      //   setState(() {
      //     _menus = List<String>.from(data);
      //   });
      // } else {
      //   throw Exception('Failed to load menus');
      // }
    } catch (e) {
      showSnackBar("Error fetching menus: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchRestaurants(String menu) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/wishlistmenu/restaurants/?menu=$menu'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _restaurants = List<Map<String, dynamic>>.from(data);
          _selectedRestaurant = null;
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      showSnackBar("Error fetching restaurants: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final request = context.read<CookieRequest>();

      final response = await request.post(
        'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/wishlistmenu/add-to-wishlistmenu/',
        {
          'menu': _selectedMenu,
          'restaurant': _selectedRestaurant,
        },
      );

      if (!mounted) return;

      if (response['success']) {
        showSnackBar("Successfully added to wishlist!", isError: false);
        Navigator.pop(context, true);
      } else {
        throw Exception(response['message'] ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      showSnackBar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add to Wishlist',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Menu and Restaurant',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedMenu,
                          decoration: InputDecoration(
                            labelText: 'Menu',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.restaurant_menu),
                          ),
                          items: _menus.map((menu) {
                            return DropdownMenuItem(
                              value: menu,
                              child: Text(menu),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a menu';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedMenu = value;
                                _selectedRestaurant = null;
                              });
                              _fetchRestaurants(value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_restaurants.isNotEmpty) ...[
                          DropdownButtonFormField<String>(
                            value: _selectedRestaurant,
                            decoration: InputDecoration(
                              labelText: 'Restaurant',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.store),
                            ),
                            items: _restaurants.map((restaurant) {
                              return DropdownMenuItem(
                                value: restaurant['id'].toString(),
                                child: Text(restaurant['name']),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a restaurant';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() => _selectedRestaurant = value);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add to Wishlist',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
