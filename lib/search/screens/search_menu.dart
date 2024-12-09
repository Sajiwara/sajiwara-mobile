import 'package:flutter/material.dart';
import 'package:sajiwara/widgets/left_drawer.dart';

class SearchResto extends StatefulWidget {
  const SearchResto({super.key});

  @override
  State<SearchResto> createState() => _SearchRestoPageState();
}

class _SearchRestoPageState extends State<SearchResto> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const LeftDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.deepOrange),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.deepOrange),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Find Your\nFavorite Food!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.tune),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _categoryButton('All', 0),
                    const SizedBox(width: 8),
                    _categoryButton('Indonesian', 1),
                    const SizedBox(width: 8),
                    _categoryButton('Western', 2),
                    const SizedBox(width: 8),
                    _categoryButton('Chinese', 3),
                    const SizedBox(width: 8),
                    _categoryButton('Middle Eastern', 4),
                    const SizedBox(width: 8),
                    _categoryButton('Japanese', 5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'Belum ada pencarian',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity, // Make the container full width
                    child: Text(
                      'Mau Makan Apa\nHari ini?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _selectedIndex == index ? Colors.white : Colors.black87,
        backgroundColor: _selectedIndex == index ? Colors.deepOrange : Colors.grey[200],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(title),
    );
  }
}