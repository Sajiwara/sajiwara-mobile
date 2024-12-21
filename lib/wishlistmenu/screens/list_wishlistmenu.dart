import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/wishlistmenu/models/wishlistmenu_entry.dart';
import 'form_wishlistmenu.dart';

class WishlistMenuList extends StatefulWidget {
  const WishlistMenuList({super.key});

  @override
  State<WishlistMenuList> createState() => _WishlistMenuListState();
}

class _WishlistMenuListState extends State<WishlistMenuList> {
  List<WishlistMenu> _wishlistItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  Future<void> _fetchWishlist() async {
    setState(() => _isLoading = true);
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get(
        'http://127.0.0.1:8000/wishlistmenu/json/',
      );

      if (response != null) {
        List<dynamic> jsonResponse = response;
        setState(() {
          _wishlistItems = jsonResponse.map((item) => 
            WishlistMenu.fromJson(item)
          ).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching wishlist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsTried(String id) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        'http://127.0.0.1:8000/wishlistmenu/visited-flutter/$id/',
        {},
      );

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully marked as tried!'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchWishlist();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking as tried: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        'http://127.0.0.1:8000/wishlistmenu/deletewishlist-flutter/$id/',
        {},
      );

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully deleted from wishlist!'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchWishlist();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist Menu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlistItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No items in your wishlist',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WishlistMenuFormPage(),
                            ),
                          );
                          if (result == true) {
                            _fetchWishlist();
                          }
                        },
                        child: const Text('Add your first item'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchWishlist,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _wishlistItems.length,
                    itemBuilder: (context, index) {
                      final item = _wishlistItems[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.fields.menuWanted,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'from ${item.fields.restaurant}', // Asumsi keterangan resto ada pada field 'resto'
                                          style: const TextStyle(
                                            fontSize: 14, // Ukuran font lebih kecil dari menu
                                            fontFamily: 'Item', // Gaya font "Item" jika sudah terdaftar
                                            color: Colors.grey, // Warna font lebih lembut
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          item.fields.tried
                                              ? Icons.check_circle
                                              : Icons.check_circle_outline,
                                          color: item.fields.tried
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 28,
                                        ),
                                        onPressed: () => _markAsTried(item.pk),
                                        tooltip: item.fields.tried
                                            ? 'Tried'
                                            : 'Not tried',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 28,
                                        ),
                                        onPressed: () => _deleteItem(item.pk),
                                        tooltip: 'Delete from wishlist',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (item.fields.tried) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.green[200]!,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Tried',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WishlistMenuFormPage(),
            ),
          );
          if (result == true) {
            _fetchWishlist();
          }
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}