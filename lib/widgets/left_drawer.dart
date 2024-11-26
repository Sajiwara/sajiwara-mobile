import 'package:flutter/material.dart';
import 'package:sajiwara/screens/menu.dart';

// TODO: Import semua inian kalian aja dah

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fastfood_rounded,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'Sajiwara',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Eksplor Makanan dan Restoran Jogja",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home_outlined,
            text: 'Halaman Utama',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.search,
            text: 'Search',
            // TODO: masukkan routing
            // NOTE INI BIAR JALAN!!
            onTap: () => _showSnackBar(context, 'Menu Search ditekan'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.explore,
            text: 'Explore Makanan',
            // TODO: masukkan routing
            // NOTE INI BIAR JALAN!!
            onTap: () => _showSnackBar(context, 'Menu Explore Makanan ditekan'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.restaurant,
            text: 'Add Wishlist Resto',
            // TODO: masukkan routing
            // NOTE INI BIAR JALAN!!
            onTap: () => _showSnackBar(context, 'Menu Wishlist Resto ditekan'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.fastfood,
            text: 'Add Wishlist Food',
            // TODO: masukkan routing
            // NOTE INI BIAR JALAN!!
            onTap: () => _showSnackBar(context, 'Menu Wishlist Food ditekan'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.reviews,
            text: 'Review',
            // TODO: masukkan routing
            // NOTE INI BIAR JALAN!!
            onTap: () => _showSnackBar(context, 'Menu Review ditekan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
