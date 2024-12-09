import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatelessWidget {
  final List<String> categories = ['All', 'Indonesian', 'Western', 'Chinese'];

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu Icon
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              
              const SizedBox(height: 20),
              
              // Search Text
              const Text(
                'Search',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.deepOrange,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Find Your Favorite Food Text
              const Text(
                'Find Your\nFavorite Food!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Restaurant',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Categories
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text(categories[index]),
                        backgroundColor: index == 0 ? Colors.deepOrange : Colors.grey[300],
                        labelStyle: TextStyle(
                          color: index == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Nearest Section
              const Text(
                'Nearest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: RestoCard(
                        name: 'Resto Cak Imin',
                        rating: 5.0,
                        distance: 10,
                        price: 10000,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Most Rated Section
              const Text(
                'Most Rated',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: RestoCard(
                        name: 'Resto Cak Imin',
                        rating: 5.0,
                        distance: 10,
                        price: 10000,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestoCard extends StatelessWidget {
  final String name;
  final double rating;
  final int distance;
  final int price;

  const RestoCard({
    super.key,
    required this.name,
    required this.rating,
    required this.distance,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text('$rating'),
                    const SizedBox(width: 5),
                    Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                    Text('$distance km'),
                    const SizedBox(width: 5),
                    Icon(Icons.monetization_on, color: Colors.grey[600], size: 16),
                    Text('${price}k'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
