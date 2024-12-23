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
      final response = await request.get(
          'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/review/get-user-info/');
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
        'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/review/delete-flutter/$reviewId/',
        {'_method': 'DELETE'},
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        setState(() {
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
      final response = await request.get(
          'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/review/${widget.id}/jsonReview/');

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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReviewEntryFormPage(restaurantId: widget.id),
                ),
              );

              if (result == true) {
                setState(() {
                  _reviewListFuture =
                      fetchReviews(context.read<CookieRequest>());
                });
              }
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
      backgroundColor: Colors.deepOrange.shade400,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Review>>(
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "By: ${review.user.username}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                              Text(
                                review.review,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (currentUserId == review.user.id) ...[
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditReviewScreen(
                                              reviewId: review.id,
                                              initialReviewText: review.review,
                                            ),
                                          ),
                                        ).then((updatedReviewText) {
                                          if (updatedReviewText != null) {
                                            setState(() {
                                              review.review = updatedReviewText;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        deleteReview(review.id);
                                      },
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
