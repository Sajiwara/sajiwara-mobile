import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sajiwara/tipemakanan/screens/edit_makanan.dart';
import 'package:sajiwara/tipemakanan/models/models_tipemakanan.dart';

class MakananList extends StatefulWidget {
  const MakananList({super.key});

  @override
  State<MakananList> createState() => _MakananListState();
}

class _MakananListState extends State<MakananList> {
  List<ProductEntry> makananList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMakanan();
  }

  Future<void> fetchMakanan() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/tipemakanan/json/')); // URL API
      if (response.statusCode == 200) {
        setState(() {
          makananList = productEntryFromJson(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load makanan');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Makanan'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: makananList.length,
                itemBuilder: (context, index) {
                  final makanan = makananList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.orange.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            makanan.fields.restoran,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            makanan.fields.preferensi
                                .toString()
                                .split('.')
                                .last,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditMakanan(id: makanan.pk),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sajiwara/tipemakanan/screens/edit_makanan.dart';
// import 'package:sajiwara/tipemakanan/models/models_tipemakanan.dart';

// class MakananList extends StatefulWidget {
//   const MakananList({super.key});

//   @override
//   State<MakananList> createState() => _MakananListState();
// }

// class _MakananListState extends State<MakananList> {
//   List makananList = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> fetchMakanan() async {
//     final response =
//         await http.get(Uri.parse('http://127.0.0.1:8000/tipemakanan/json/'));
//     if (response.statusCode == 200) {
//       setState(() {
//         makananList = json.decode(response.body);
//         print("test 1 fetching");
//         print(makananList);
//       });
//     } else {
//       throw Exception('Failed to load makanan');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Explore Makanan'),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: makananList.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                 ),
//                 itemCount: makananList.length,
//                 itemBuilder: (context, index) {
//                   final makanan = makananList[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     color: Colors.orange.shade300,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             makanan['restoran'] ?? 'Resto ${index + 1}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             makanan['preferensi'] ?? 'Negara',
//                             style: const TextStyle(color: Colors.white70),
//                           ),
//                           const Spacer(),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => EditMakanan(
//                                     id: makanan['id'],
//                                   ),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange.shade700,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text('Edit'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
