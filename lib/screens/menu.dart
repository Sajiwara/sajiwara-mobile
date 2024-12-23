import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/screens/login.dart';
import 'package:sajiwara/tipemakanan/screens/makananlist.dart';
import 'package:sajiwara/widgets/left_drawer.dart';
import 'package:sajiwara/wishlistresto/screens/menu_wishlistresto.dart';
import 'package:sajiwara/wishlistmenu/screens/menu_wishlistmenu.dart';
import 'package:sajiwara/review/screens/list_restaurant.dart';
import 'package:sajiwara/search/screens/search_menu.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<ItemHomepage> items = [
    ItemHomepage("Search", Icons.search, Colors.blue),
    ItemHomepage("Explore Makanan", Icons.restaurant, Colors.green),
    ItemHomepage("Add Wishlist Resto", Icons.favorite_border, Colors.red),
    ItemHomepage("Add Wishlist Food", Icons.fastfood, Colors.orange),
    ItemHomepage("Review", Icons.rate_review, Colors.purple),
    ItemHomepage("Logout", Icons.logout, Colors.deepPurple),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Animated Background
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(
              color:
                  Colors.white, // Mengubah warna ikon hamburger menjadi putih
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Sajiwara',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/food_background.png',
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid of Menu Items
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: items.map((ItemHomepage item) {
                return ItemCard(item, request);
              }).toList(),
            ),
          ),
        ],
      ),
      drawer: const LeftDrawer(),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, CookieRequest request, {super.key});

  void _handleItemTap(BuildContext context, CookieRequest request) async {
    switch (item.name) {
      case "Add Wishlist Resto":
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WishlistResto(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOutQuart;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
        break;
      case "Logout":
        final response = await request.logout(
            // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
            // "http://127.0.0.1:8000/auth/logout/");

            "https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/auth/logout/");
        String message = response["message"];
        if (context.mounted) {
          if (response['status']) {
            String uname = response["username"];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("$message Sampai jumpa, $uname."),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
        break;
      case "Review":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RestaurantPage(),
          ),
        );
        break;
      case "Search":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchResto(),
          ),
        );
        break;
      case "Add Wishlist Food":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WishlistMenu(),
          ),
        );
        break;
      case "Explore Makanan":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MakananList(),
          ),
        );
        break;
      default: // TODO: add routing kalian
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("You pressed ${item.name}!")),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _handleItemTap(context, request),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                item.color.withOpacity(0.7),
                item.color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  item.icon,
                  color: Colors.white.withOpacity(0.7),
                  size: 40.0,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}
