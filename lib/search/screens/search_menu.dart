import 'package:flutter/material.dart';

class SearchFoodPage extends StatelessWidget {
  const SearchFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Icon
              Column(
                children: [
                  Image.asset(
                    "assets/icon.png",
                    width: 27,
                    height: 15,
                  ),
                ],
              ),
              
              // Search Text
              const Text(
                "Search",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              // Find Food Text
              const Text(
                "Find Your\nFavorite Food!",
                style: TextStyle(
                  fontSize: 35.83,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              // Indonesian Text
              const Text(
                "Mau Makan Apa\nHari ini?",
                style: TextStyle(
                  fontSize: 35.83,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              // Search Bar
              Stack(
                children: [
                  Container(
                    width: 343.84,
                    height: 41,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xffc9c9c9),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 12,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/Icon.png",
                          width: 13.23,
                          height: 13.23,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 17.65,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Category List
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryItem("All"),
                    _buildCategoryItem("Chinese"),
                    _buildCategoryItem("Western"),
                    _buildCategoryItem("Indonesian"),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // No Search Text
              const Center(
                child: Text(
                  "Belum ada pencarian",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
              // Bottom Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/tone.png",
                    width: 16,
                    height: 18,
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    "assets/shape.png",
                    width: 16,
                    height: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
