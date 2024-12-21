import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/review/models/models_Review.dart';
import 'package:sajiwara/review/screens/form_reviewEntry.dart';
import 'package:sajiwara/review/screens/form_editEntry.dart';

class ReviewListPage extends StatefulWidget {
  final String id;

  const ReviewListPage({super.key, required this.id});

  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  late Future<List<Review>> _reviewListFuture;
  int? currentUserId;

  Future<int?> getUserId(CookieRequest request) async {
    try {
      final response =
          await request.get('http://127.0.0.1:8000/review/get-user-info/');
      if (response is Map && response.containsKey("id")) {
        return response["id"];
      } else {
        print("Invalid response: $response");
      }
    } catch (e) {
      print("Error fetching user info: $e");
    }
    return null;
  }

  Future<void> deleteReview(String reviewId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/review/delete-flutter/$reviewId/',
        {'_method': 'DELETE'},
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        setState(() {
          // Refresh review list after deletion
          _reviewListFuture = fetchReviews(request);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response['error']}")),
        );
      }
    } catch (e) {
      print("Error deleting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete review.")),
      );
    }
  }

  Future<List<Review>> fetchReviews(CookieRequest request) async {
    try {
      final response = await request
          .get('http://127.0.0.1:8000/review/${widget.id}/jsonReview/');

      if (response is List) {
        return response.map((item) => Review.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => Review.fromJson(item))
            .toList();
      } else {
        throw FormatException('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();

    getUserId(request).then((id) {
      setState(() {
        currentUserId = id;
      });
    });

    _reviewListFuture = fetchReviews(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReviewEntryFormPage(restaurantId: widget.id),
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
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reviews available."));
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text("Review: ${review.fields.review}"),
                    subtitle: Text("User: ${review.fields.user}"),
                    trailing: currentUserId == review.fields.user
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to edit review form
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditReviewScreen(
                                          reviewId: review.pk,
                                          initialReviewText:
                                              review.fields.review,
                                        ),
                                      ));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                  deleteReview(
                                      review.pk); // Call delete function
                                },
                              ),
                            ],
                          )
                        : null,
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
