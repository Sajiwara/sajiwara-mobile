import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sajiwara/review/models/models_Restor.dart';
import 'package:sajiwara/widgets/left_drawer.dart';
import 'package:sajiwara/review/screens/list_review.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late Future<List<Restor>> _restoListFuture;
  List<Restor> _filteredRestoList = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _restoListFuture = fetchResto(CookieRequest());
  }

  Future<List<Restor>> fetchResto(CookieRequest request) async {
    try {
      final response =
          await request.get('http://127.0.0.1:8000/review/jsonResto/');

      if (response is String && response.contains('<html>')) {
        throw FormatException('Invalid response format: HTML received');
      }

      if (response is List) {
        return response.map((item) => Restor.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => Restor.fromJson(item))
            .toList();
      }

      throw FormatException('Unexpected response format');
    } catch (e) {
      print('Error fetching restaurants: $e');
      return [];
    }
  }

  void _filterRestoList(String query, List<Restor> originalList) {
    setState(() {
      _searchQuery = query;
      _filteredRestoList = originalList
          .where((resto) => resto.fields.restaurant
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const LeftDrawer(),
      body: Stack(
        children: [
          Container(color: Colors.orange),
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenWidth * 0.03,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Review Restoran",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              onChanged: (query) {
                                _restoListFuture.then((originalList) {
                                  _filterRestoList(query, originalList);
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Find Restaurants...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<Restor>>(
                      future: _restoListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading data'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No restaurants found'));
                        } else {
                          final restoList = _searchQuery.isEmpty
                              ? snapshot.data!
                              : _filteredRestoList;

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: restoList.length,
                            itemBuilder: (_, index) {
                              final resto = restoList[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B6B)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: Color(0xFFFF6B6B),
                                    ),
                                  ),
                                  title: Text(
                                    resto.fields.restaurant,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Rating: " + resto.fields.rating.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(221, 107, 107, 107),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewListPage(
                                            id:
                                            resto.pk,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF6B6B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'See Reviews',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
