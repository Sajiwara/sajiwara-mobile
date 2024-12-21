import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditReviewScreen extends StatefulWidget {
  final String reviewId;
  final String initialReviewText;

  EditReviewScreen({required this.reviewId, required this.initialReviewText});

  @override
  _EditReviewScreenState createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _reviewController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController(text: widget.initialReviewText);
  }

  Future<void> _editReview(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final url =
        'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/review/edit-flutter/${widget.reviewId}/';
    final response = await request.post(
      url,
      json.encode({
        'review_text': _reviewController.text,
      }),
    );

    if (response['status'] == 'success') {
      // Mengirimkan data review yang sudah diperbarui
      Navigator.pop(
          context, _reviewController.text); // Mengirimkan teks review yang baru
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update review.')),
      );
    }
    // if (response.statusCode == 200) {
    //   final responseData = json.decode(response.body);
    //   if (responseData['status'] == 'success') {
    //     // Mengirimkan data review yang sudah diperbarui
    //     Navigator.pop(context,
    //         _reviewController.text); // Mengirimkan teks review yang baru
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to update review.')),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Server error. Please try again later.')),
    //   );
    // }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Edit your review',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Review cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _editReview(request),
                      child: Text('Save Changes'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
