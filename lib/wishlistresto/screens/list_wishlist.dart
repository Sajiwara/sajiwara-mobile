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
    // URL API untuk mendapatkan data wishlist
    final response = await request.get(
        'http://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/wishlist/json/');

    // Decode response JSON
    return wishlistRestoFromJson(jsonEncode(response));
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
                      Text(
                        "User ID: ${wishlist.fields.user}",
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Wanted Resto: ${wishlist.fields.wantedResto ? "Yes" : "No"}",
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
