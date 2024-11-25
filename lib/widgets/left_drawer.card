import 'package:flutter/material.dart';
import 'package:sajiwara-mobile/screens/menu.dart';
import 'package:sajiwara-mobile/screens/moodentry_form.dart';
import 'package:sajiwara-mobile/screens/list_moodentry.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Sajiwara',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Eksplor Makanan dan Restoran Jogja",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Search'),
            onTap: () {
              // Route menu ke Search
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodEntryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.mood),
            title: const Text('Explore Makanan'),
            // Bagian redirection ke Explore Makanan
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodEntryFormPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Add Wishlist Resto'),
            onTap: () {
              // Route menu ke Wishlist Resto
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodEntryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Add Wishlist Food'),
            onTap: () {
              // Route menu ke Wishlist Food
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodEntryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Review'),
            onTap: () {
              // Route menu ke Review
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodEntryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
