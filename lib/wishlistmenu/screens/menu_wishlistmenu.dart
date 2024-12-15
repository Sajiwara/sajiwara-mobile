import 'package:flutter/material.dart';
import 'package:sajiwara/screens/menu.dart';
import 'package:sajiwara/widgets/left_drawer.dart';
import 'package:sajiwara/wishlistmenu/screens/form_wishlistmenu.dart';
import 'package:sajiwara/wishlistmenu/models/wishlistmenu_entry.dart';

class WishlistMenu extends StatefulWidget {
  const WishlistMenu({Key? key}) : super(key: key);

  @override
  State<WishlistMenu> createState() => _WishlistMenuState();
}

class _WishlistMenuState extends State<WishlistMenu> {
  String activeCategory = 'wishlist';
  List<WishlistMenuItem> _wishlistItems = [];
  List<WishlistMenuItem> _triedItems = [];
  bool _isLoading = true;
  String? _error;
  bool isTried = false; 

  @override
  void initState() {
    super.initState();
    _fetchWishlistMenus();
  }

  Future<void> _fetchWishlistMenus() async {
    try {
      final items = await fetchWishlistMenus();

      setState(() {
        _wishlistItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void setActiveCategory(String category) {
    setState(() {
      activeCategory = category;
    });
  }

  Future<void> _updateTriedStatus(String id, bool tried) async {
    try {
      await WishlistMenuItem.updateTriedStatus(id, tried);
      _fetchWishlistMenus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
      );
    }
  }

  Future<void> _deleteWishlistItem(String id) async {
    try {
      await WishlistMenuItem.deleteWishlistItem(id);
      _fetchWishlistMenus();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist Menu',
          style: TextStyle(color: Colors.deepOrange),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Card(
                elevation: 10,
                shadowColor: Colors.deepOrange[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sajiwara',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Your Wishlist Menu',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The Perfect Spot for Your Favorite Finds',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _infoTile(_wishlistItems.length.toString(),
                                    'Wishlist'),
                                _infoTile(
                                    _wishlistItems
                                        .where((item) => item.tried)
                                        .length
                                        .toString(),
                                    'Experienced'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/images/menu-wishlist.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 14, left: 14),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA726),
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  final bool? result = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return const FormWishListMenu();
                    },
                  );

                  if (result == true) {
                    _fetchWishlistMenus();
                  }
                },
                child: const Text(
                  'Add Your Wishlist Here',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeCategory == 'wishlist'
                          ? Color(0xFFDD6E42)
                          : Color(0xFFD4C7C3),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => setActiveCategory('wishlist'),
                    child: const Text(
                      'View My Wishlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeCategory == 'discover'
                          ? Color(0xFFDD6E42)
                          : Color(0xFFD4C7C3),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        activeCategory = 'discover';
                        isTried =
                            true; 
                      });
                    },
                    child: Text(
                      'Discover Food Experiences',
                      style: TextStyle(
                        color: activeCategory == 'discover'
                            ? Colors.white
                            : Color(0xFFDD6E42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (activeCategory == 'wishlist') ...[
              Center(
                child: const Text(
                  'My Wishlist',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDD6E42),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = _wishlistItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 10,
                              shadowColor: Colors.black.withOpacity(1),
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/wishlist.png',
                                  width: 70.0,
                                  height: 70.0,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  item.menuName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDD6E42),
                                  ),
                                ),
                                subtitle: Text(
                                  item.restaurantName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        item.tried
                                            ? Icons.check_circle
                                            : Icons.check_circle_outline,
                                        color: const Color(0xFFDD6E42),
                                      ),
                                      onPressed: () {
                                        _updateTriedStatus(
                                            item.id, !item.tried);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFFDD6E42),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin menghapus item ini?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Batal'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Hapus'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _deleteWishlistItem(item.id);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
            if (activeCategory == 'discover' && isTried) ...[
              Center(
                child: const Text(
                  'My Food Experience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDD6E42),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              _wishlistItems.where((item) => item.tried).length,
                          itemBuilder: (context, index) {
                            final item = _wishlistItems
                                .where((item) => item.tried)
                                .toList()[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 10,
                              shadowColor: Colors.black.withOpacity(1),
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/food.png',
                                  width: 70.0,
                                  height: 70.0,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  item.menuName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDD6E42),
                                  ),
                                ),
                                subtitle: Text(
                                  item.restaurantName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.thumb_up,
                                        color: Color(0xFFDD6E42),
                                      ),
                                      onPressed: () {
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFFDD6E42),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin menghapus item ini?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Batal'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Hapus'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _deleteWishlistItem(item.id);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[700],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}