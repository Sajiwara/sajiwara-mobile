import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sajiwara/review/models/models_Review.dart';
import 'package:sajiwara/review/screens/form_reviewEntry.dart';

class ReviewListPage extends StatefulWidget {
  final String id;

  const ReviewListPage({super.key, required this.id});

  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  late Future<List<Review>> _reviewListFuture;
  
  

  int currentUserId = 4; //ubah yang ini

  @override
  void initState() {
    super.initState();
    _reviewListFuture = fetchReviews(CookieRequest());
  }

  Future<List<Review>> fetchReviews(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/review/${widget.id}/jsonReview/');
      print(response); // Debug: Cek data yang diterima dari server

      if (response is String && response.contains('<html>')) {
        throw FormatException('Invalid response format: HTML content received');
      }

      if (response is List) {
        return response.map((item) => Review.fromJson(item)).toList();
      }

      if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => Review.fromJson(item))
            .toList();
      }

      throw FormatException('Unexpected response format');
    } catch (e, stackTrace) {
      print('Error fetching reviews: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewEntryFormPage(restaurantId: widget.id),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange,
      body: FutureBuilder<List<Review>>(
        future: _reviewListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No reviews available."),
            );
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User ID: ${review.fields.user}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Restaurant: ${review.fields.restaurant}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Review: ${review.fields.review}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Posted on: ${review.fields.datePosted.toLocal()}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        // Show the button only if the current user is the same as the reviewer
                        if (review.fields.user == currentUserId)
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                // Action for the button (edit or delete)
                              },
                              child: const Text('Edit / Delete'),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
