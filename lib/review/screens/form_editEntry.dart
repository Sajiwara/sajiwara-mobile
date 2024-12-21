import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';

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

  Future<void> _editReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    print(widget.reviewId);

    final url = Uri.parse('http://127.0.0.1:8000/review/edit-flutter/${widget.reviewId}/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'review_text': _reviewController.text,
      }),
    );

    print("bisakah");
    if (response.statusCode == 200) {
      print("disini");
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['status'] == 'success') {
        Navigator.pop(
            context, responseData['html']); // Return updated reviews HTML
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update review.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error. Please try again later.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: _editReview,
                      child: Text('Save Changes'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
