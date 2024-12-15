import 'package:flutter/material.dart';
import '../models/wishlistmenu_entry.dart';
import 'package:sajiwara/screens/login.dart';
import 'package:sajiwara/screens/menu.dart';

class FormWishListMenu extends StatefulWidget {
  const FormWishListMenu({super.key});

  @override
  State<FormWishListMenu> createState() => _FormWishListMenuState();
}

class _FormWishListMenuState extends State<FormWishListMenu> {
  List<Menu> _menus = [];
  List<Restaurant> _restaurants = [];
  Menu? _selectedMenu;
  Restaurant? _selectedRestaurant;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    try {
      setState(() => _isLoading = true);
      final menus = await WishlistMenuApi.getMenus();
      setState(() {
        _menus = menus;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat daftar menu: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRestaurants(String menuName) async {
    try {
      setState(() => _isLoading = true);
      final response = await WishlistMenuApi.getRestaurants(menuName);
      setState(() {
        _restaurants = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat daftar restoran: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tambah Wishlist Menu',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange[700],
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Menu>(
                        value: _selectedMenu,
                        decoration: InputDecoration(
                          labelText: 'Pilih Menu',
                          labelStyle: TextStyle(color: Colors.deepOrange[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.deepOrange[200]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.deepOrange[200]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.deepOrange[400]!),
                          ),
                        ),
                        items: _menus.map((Menu menu) {
                          return DropdownMenuItem<Menu>(
                            value: menu,
                            child: Text(menu.menu),
                          );
                        }).toList(),
                        onChanged: (Menu? newValue) {
                          setState(() {
                            _selectedMenu = newValue;
                            _selectedRestaurant = null;
                          });
                          if (newValue != null) {
                            _loadRestaurants(newValue.menu);
                          }
                        },
                        hint: const Text('Pilih Menu'),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: DropdownButtonFormField<Restaurant>(
                          value: _selectedRestaurant,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Pilih Restoran',
                            labelStyle: TextStyle(color: Colors.deepOrange[700]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.deepOrange[200]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.deepOrange[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.deepOrange[400]!),
                            ),
                          ),
                          items: _restaurants.map((Restaurant restaurant) {
                            return DropdownMenuItem<Restaurant>(
                              value: restaurant,
                              child: Text(
                                restaurant.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: _selectedMenu == null
                              ? null
                              : (Restaurant? newValue) {
                                  setState(() {
                                    _selectedRestaurant = newValue;
                                  });
                                },
                          hint: const Text('Pilih Restoran'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Batal',
                              style: TextStyle(color: Colors.deepOrange[300]),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: (_selectedMenu != null &&
                                    _selectedRestaurant != null)
                                ? () async {
                                    try {
                                      await WishlistMenuApi.addToWishlist(
                                        _selectedMenu!.menu,
                                        _selectedRestaurant!.id,
                                      );
                                      Navigator.pop(context, true);
                                    } catch (e) {
                                      String message = 'Gagal menambahkan ke wishlist';
                                      if (e.toString().contains('login')) {
                                        message = 'Silakan login terlebih dahulu';
                                        Navigator.pushReplacementNamed(
                                          context, 
                                          '/authentication/login'
                                        );
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(message),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[400],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}