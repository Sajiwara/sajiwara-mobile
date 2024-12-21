import 'package:flutter/material.dart';
import 'package:sajiwara/search/models/resto_entry.dart';
import 'package:sajiwara/search/screens/resto_card.dart';
import 'package:sajiwara/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SearchResto extends StatefulWidget {
  const SearchResto({super.key});

  @override
  State<SearchResto> createState() => _SearchRestoPageState();
}

class _SearchRestoPageState extends State<SearchResto> {
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> _allRestaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  bool _isLoading = false;
  bool _isSearchInitiated = false; // Flag to check if search has been initiated
  String _searchMessage = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadRestaurants() async {
    final request = context.read<CookieRequest>();
    try {
      final restaurants = await fetchProduct(request);
      setState(() {
        _allRestaurants = restaurants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Restaurant>> fetchProduct(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/search/json/');
    var data = response;

    List<Restaurant> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Restaurant.fromJson(d));
      }
    }
    return listProduct;
  }

  void _filterRestaurants(String query) {
    if (query.isNotEmpty) {
      _loadRestaurants().then((_) {
        setState(() {
          _searchMessage = query.isEmpty
              ? 'Belum ada pencarian'
              : 'Hasil pencarian untuk: $query';
          _filteredRestaurants = _allRestaurants
              .where((resto) =>
                  resto.fields.nama.toLowerCase().contains(query.toLowerCase()))
              .toList();
          _isSearchInitiated = true;
          print(_allRestaurants);
        });
      });
    } else {
      setState(() {
        _searchMessage = "";
        _isSearchInitiated = false;
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _isLoading = true;
    });
    _filterRestaurants(query);
  }

  void _sortByName() {
    setState(() {
      _filteredRestaurants
          .sort((a, b) => a.fields.nama.compareTo(b.fields.nama));
    });
  }

  void _sortByRating() {
    setState(() {
      _filteredRestaurants
          .sort((a, b) => b.fields.rating.compareTo(a.fields.rating));
    });
  }

  void _sortByDistance() {
    setState(() {
      _filteredRestaurants
          .sort((a, b) => a.fields.jarak.compareTo(b.fields.jarak));
    });
  }

  void _sortByPrice() {
    setState(() {
      _filteredRestaurants
          .sort((a, b) => a.fields.harga.compareTo(b.fields.harga));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text('Search Restoran'),
        backgroundColor: Colors.deepOrange,
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
                controller: _searchController,
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: _openFilterDialog,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                _searchMessage,
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : !_isSearchInitiated
                      ? Center(
                          child: Text(
                            'Mau Makan Apa\nHari ini?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : _filteredRestaurants.isEmpty
                          ? Center(
                              child: Text(
                                'No restaurants found',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredRestaurants.length,
                              itemBuilder: (context, index) {
                                return RestoCard(
                                    resto: _filteredRestaurants[index]);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Sort by Name'),
                onTap: () {
                  Navigator.pop(context);
                  _sortByName();
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Sort by Rating'),
                onTap: () {
                  Navigator.pop(context);
                  _sortByRating();
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_walk_rounded),
                title: const Text('Sort by Distance'),
                onTap: () {
                  Navigator.pop(context);
                  _sortByDistance();
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Sort by Price'),
                onTap: () {
                  Navigator.pop(context);
                  _sortByPrice();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
