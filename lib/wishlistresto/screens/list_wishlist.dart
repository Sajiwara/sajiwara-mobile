import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/wishlistresto/models/wishlistresto_entry.dart';
import 'package:sajiwara/widgets/left_drawer.dart';
import 'package:sajiwara/wishlistresto/screens/form_wishlistresto.dart';

class WishlistRestoEntryPage extends StatefulWidget {
  const WishlistRestoEntryPage({super.key});

  @override
  State<WishlistRestoEntryPage> createState() => _WishlistRestoPageState();
}

class _WishlistRestoPageState extends State<WishlistRestoEntryPage> {
  Future<List<WishlistResto>> fetchWishlistResto(CookieRequest request) async {
    try {
      final response =
          await request.get('http://127.0.0.1:8000/wishlist/json/');

      if (response is String && response.contains('<html>')) {
        throw FormatException('Invalid response format: HTML received');
      }

      if (response is List) {
        return response.map((item) => WishlistResto.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => WishlistResto.fromJson(item))
            .toList();
      }

      throw FormatException('Unexpected response format');
    } catch (e) {
      print('Error fetching wishlist: $e');
      return [];
    }
  }

  Future<void> markAsVisited(BuildContext context, String id) async {
    final request = context.read<CookieRequest>();
    final url =
        'http://127.0.0.1:8000/wishlist/visited-flutter/$id/'; // Ganti sesuai URL Django Anda

    try {
      final response = await request.post(url, {});

      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marked as visited!')),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to mark as visited')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> deleteWishlist(BuildContext context, String id) async {
    final request = context.read<CookieRequest>();
    final url = 'http://127.0.0.1:8000/wishlist/deletewishlist-flutter/$id/';

    try {
      final response = await request.post(url, {});

      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wishlist deleted successfully')),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete wishlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'My Restaurant Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<WishlistResto>>(
        future: fetchWishlistResto(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B6B),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load wishlist',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/empty_wishlist.png',
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No restaurants in your wishlist yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WishlistRestoFormPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Add Restaurant'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final wishlistItem = snapshot.data![index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      color: const Color(0xFFFF6B6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                  title: Text(
                    wishlistItem.fields.restaurantWanted,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    wishlistItem.fields.visited ? "Visited" : "Not Visited Yet",
                    style: TextStyle(
                      color: wishlistItem.fields.visited
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!wishlistItem.fields.visited)
                        ElevatedButton(
                          onPressed: () =>
                              markAsVisited(context, wishlistItem.pk),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B6B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Mark as Visited',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: () =>
                            deleteWishlist(context, wishlistItem.pk),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WishlistRestoFormPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFF6B6B),
        child: const Icon(Icons.add),
      ),
    );
  }
}
