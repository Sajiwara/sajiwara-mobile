import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> deleteReview(String reviewId) async {
  final url = Uri.parse(
      'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/review/flutter-delete-review/$reviewId/');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        '_method': 'DELETE', // Mengindikasikan metode DELETE
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        print(data['message']); // "Review deleted successfully!"
      } else {
        print("Error: ${data['error']}");
      }
    } else {
      print("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
