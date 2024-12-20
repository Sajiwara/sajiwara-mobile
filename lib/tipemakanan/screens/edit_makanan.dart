import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/tipemakanan/screens/makananlist.dart';
import 'package:sajiwara/widgets/left_drawer.dart';

class EditMakanan extends StatefulWidget {
  final int id;
  const EditMakanan({super.key, required this.id});

  @override
  State<EditMakanan> createState() => _EditMakananState();
}

class _EditMakananState extends State<EditMakanan> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController preferensiController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  bool isLoading = true;

  Future<void> fetchMakananDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/tipemakanan/json/${widget.id}/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            namaController.text = data[0]['fields']['restoran'] ?? '';
            preferensiController.text = data[0]['fields']['preferensi'] ?? '';
            menuController.text = data[0]['fields']['menu'] ?? '';
            isLoading = false;
          });
        } else {
          throw Exception('Data kosong');
        }
      } else {
        throw Exception(
            'Failed to load makanan details: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateMakanan(CookieRequest request) async {
    try {
      print("halo");
      final response = await http.post(
        Uri.parse(
            'http://127.0.0.1:8000/tipemakanan/edit-flutter/${widget.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'restoran': namaController.text,
          'preferensi': preferensiController.text,
          'menu': menuController.text,
        }),
      );
      print("watashi");
      print(response.statusCode);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MakananList(),
          ),
        );
      } else {
        throw Exception('Failed to update makanan');
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMakananDetail();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Makanan'),
        backgroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Restoran',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: preferensiController,
                    decoration: InputDecoration(
                      labelText: 'Preferensi Negara',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: menuController,
                    decoration: InputDecoration(
                      labelText: 'Menu Makanan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 5, // Tambahkan ini untuk mendukung teks panjang
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      updateMakanan(request);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class EditMakanan extends StatefulWidget {
//   final int id;
//   const EditMakanan({super.key, required this.id});

//   @override
//   State<EditMakanan> createState() => _EditMakananState();
// }

// class _EditMakananState extends State<EditMakanan> {
//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController preferensiController = TextEditingController();
//   final TextEditingController menuController = TextEditingController();
//   bool isLoading = true;

//   Future<void> fetchMakananDetail() async {
//     try {
//       final response = await http.get(
//           Uri.parse('http://127.0.0.1:8000/tipemakanan/${widget.id}/json/'));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body)[0];
//         setState(() {
//           namaController.text = data['fields']['restoran'] ?? '';
//           preferensiController.text = data['fields']['preferensi'] ?? '';
//           menuController.text = data['fields']['menu'] ?? '';
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load makanan details');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error fetching data: $e");
//     }
//   }

//   Future<void> updateMakanan() async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:8000/tipemakanan/edit/${widget.id}/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'restoran': namaController.text,
//           'preferensi': preferensiController.text,
//           'menu': menuController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         Navigator.pop(context);
//       } else {
//         throw Exception('Failed to update makanan');
//       }
//     } catch (e) {
//       print("Error updating data: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchMakananDetail();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Makanan'),
//         backgroundColor: Colors.orange,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: namaController,
//                     decoration: InputDecoration(
//                       labelText: 'Nama Restoran',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: preferensiController,
//                     decoration: InputDecoration(
//                       labelText: 'Preferensi Negara',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: menuController,
//                     decoration: InputDecoration(
//                       labelText: 'Variasi Makanan',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   ElevatedButton(
//                     onPressed: updateMakanan,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Simpan Perubahan',
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

