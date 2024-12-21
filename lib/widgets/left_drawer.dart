import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:sajiwara-mobile/screens/menu.dart';
import 'package:sajiwara-mobile/screens/moodentry_form.dart';
import 'package:sajiwara-mobile/screens/list_moodentry.dart';
=======
import 'package:sajiwara/review/screens/list_restaurant.dart';
import 'package:sajiwara/screens/menu.dart';
import 'package:sajiwara/search/screens/search_menu.dart';
import 'package:sajiwara/tipemakanan/screens/makananlist.dart';
import 'package:sajiwara/wishlistresto/screens/menu_wishlistresto.dart';
import 'package:sajiwara/wishlistmenu/screens/menu_wishlistmenu.dart';
>>>>>>> 20ae4f2eaaeaadc51633e59ffbfbe9a91fb67eee

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

<<<<<<< HEAD
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
=======
  void _showStyledSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFF6B6B), // Vibrant food-app red
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFEF9E7), // Light cream background
              Color(0xFFFFF3E0), // Soft pastel orange
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.home_outlined,
                    text: 'Beranda',
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    ),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.search,
                    text: 'Pencarian',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchResto(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.explore_outlined,
                    text: 'Jelajahi Makanan',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MakananList(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.restaurant_menu,
                    text: 'Daftar Restoran Favorit',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishlistResto(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.favorite_border,
                    text: 'Makanan Favorit',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishlistMenu(),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.rate_review_outlined,
                    text: 'Ulasan Saya',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RestaurantPage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  _buildDrawerFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFFF6B6B),
          size: 26,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFFFF6B6B),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          'v1.0.0 • Sajiwara',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

Widget _buildDrawerHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFF6B6B), // Vibrant food app red
          Color(0xFFFFD93D), // Warm yellow
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.restaurant_rounded,
            size: 50,
            color: Color(0xFFFF6B6B),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Sajiwara',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Petualangan Kuliner Jogja',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}
>>>>>>> 20ae4f2eaaeaadc51633e59ffbfbe9a91fb67eee
