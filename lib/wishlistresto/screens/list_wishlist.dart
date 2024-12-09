import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/wishlistresto/models/wishlistresto_entry.dart';
import 'package:sajiwara/widgets/left_drawer.dart';

class WishlistRestoEntryPage extends StatefulWidget {
  const WishlistRestoEntryPage({super.key});

  @override
  State<WishlistRestoEntryPage> createState() => _WishlistRestoPageState();
}

class _WishlistRestoPageState extends State<WishlistRestoEntryPage> {
  Future<List<WishlistResto>> fetchWishlistResto(CookieRequest request) async {
    try {
      // Mendapatkan respons dari server
      final response =
          await request.get('http://127.0.0.1:8000/wishlist/json/');

      // Debug: Cetak respons mentah
      print('Raw Response: $response');

      // Penanganan jika respons berupa HTML (kemungkinan error)
      if (response is String && response.contains('<html>')) {
        print(
            'Error: Server returned HTML instead of JSON. Possible authentication or server error.');
        throw FormatException('Invalid response format: HTML received.');
      }

      // Pastikan respons berupa List atau Map
      if (response is List) {
        // Parsing dari List
        return response.map((x) => WishlistResto.fromJson(x)).toList();
      } else if (response is Map && response.containsKey('data')) {
        // Parsing dari Map jika terdapat key 'data'
        return (response['data'] as List)
            .map((x) => WishlistResto.fromJson(x))
            .toList();
      }

      // Jika format respons tidak sesuai
      print('Unexpected response format');
      throw FormatException('Unexpected response format.');
    } catch (e) {
      // Tangani error lainnya
      print('Error fetching wishlist: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Wishlist Restoran'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchWishlistResto(request),
        builder: (context, AsyncSnapshot<List<WishlistResto>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada wishlist restoran pada Sajiwara.',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 216, 146, 89)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final wishlist = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wishlist.fields.restaurantWanted,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 5),
                      Text(
                        "${wishlist.fields.wantedResto ? "Yes" : "No"}",
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Visited: ${wishlist.fields.visited ? "Telah dikunjungi" : "Belum dikunjungi"}",
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
