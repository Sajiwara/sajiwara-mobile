

import 'package:flutter/material.dart';
import 'package:sajiwara/search/models/resto_entry.dart';
import 'package:sajiwara/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/wishlistresto/screens/form_wishlistresto.dart';

class RestoCard extends StatelessWidget {
  final Restaurant resto;

  const RestoCard({Key? key, required this.resto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resto.fields.nama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant_menu, size: 16, color: Colors.black),
                const SizedBox(width: 4),   
                Text(
                  jenisMakananValues.reverse[resto.fields.jenisMakanan]!,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${resto.fields.rating}',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 16),
                const SizedBox(width: 4),
                Text(
                  'Average price : Rp ${resto.fields.harga}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  '${resto.fields.jarak} km',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 16),
                Icon(Icons.mood, size: 16, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  suasanaValues.reverse[resto.fields.suasana]!,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Menambahkan Row baru untuk tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WishlistRestoFormPage(
                            initialRestaurant: resto.fields.nama, // Pass the restaurant name here
                          ),
                        ),
                      );
                      
                    },
                  icon: Icon(Icons.favorite_border),
                  label: Text('Add to Wishlist'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

