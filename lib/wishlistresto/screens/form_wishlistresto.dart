import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/widgets/left_drawer.dart';

class WishlistRestoFormPage extends StatefulWidget {
  const WishlistRestoFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistRestoFormPageState();
}

class _WishlistRestoFormPageState extends State<WishlistRestoFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRestaurant;
  List<String> _restaurants = [];
  bool _isLoading = false;

  Future<void> addToWishlist(String restaurant, CookieRequest request) async {
    // final url =
    //     Uri.parse('http://127.0.0.1:8000/wishlist/add-to-wishlist-flutter/');

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/wishlist/add-to-wishlist-flutter/',
        convert.jsonEncode({
          'restaurant_wanted': restaurant,
          'wanted_resto': true,
          'visited': false,
        }),
      );
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRestaurantData();
  }

  Future<void> _fetchRestaurantData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String response = await rootBundle
          .loadString('restaurants.json'); // Gunakan path yang sesuai
      final List<dynamic> data = convert.json.decode(response);

      setState(() {
        _restaurants =
            data.map((entry) => entry['Nama Restoran'] as String).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading restaurant data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Tambah Restoran ke Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[400],
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Restoran Favoritmu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                value: _selectedRestaurant,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  hintText: "Pilih Restoran",
                                  labelText: "Restoran",
                                  prefixIcon: Icon(Icons.restaurant_menu,
                                      color: Colors.deepOrange[400]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: _restaurants.map((restaurant) {
                                  return DropdownMenuItem<String>(
                                    value: restaurant,
                                    child: Text(
                                      restaurant,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRestaurant = value;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Restoran tidak boleh kosong!";
                                  }
                                  return null;
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedRestaurant != null) {
                        await addToWishlist(_selectedRestaurant!, request);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Restoran $_selectedRestaurant ditambahkan ke wishlist'),
                            backgroundColor: Colors.deepOrange[400],
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[100],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Tambah ke Wishlist',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
