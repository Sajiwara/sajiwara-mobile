import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditMakanan extends StatefulWidget {
  final int id;
  const EditMakanan({super.key, required this.id});

  @override
  State<EditMakanan> createState() => _EditMakananState();
}

class _EditMakananState extends State<EditMakanan> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController preferensiController = TextEditingController();
  final TextEditingController variasiController = TextEditingController();

  Future<void> fetchMakananDetail() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/tipemakanan/${widget.id}/json/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)[0];
      setState(() {
        namaController.text = data['nama'] ?? '';
        preferensiController.text = data['preferensi'] ?? '';
        variasiController.text = data['variasi'] ?? '';
      });
    } else {
      throw Exception('Failed to load makanan details');
    }
  }

  Future<void> updateMakanan() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/tipemakanan/edit/${widget.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nama': namaController.text,
        'preferensi': preferensiController.text,
        'variasi': variasiController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to update makanan');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMakananDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Makanan'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
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
              controller: variasiController,
              decoration: InputDecoration(
                labelText: 'Variasi Makanan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: updateMakanan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Simpan Perubahan',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class EditMakanan extends StatelessWidget {
//   const EditMakanan({super.key, required id});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Makanan'),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Nama Restoran',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Preferensi Negara',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Variasi Makanan',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               maxLines: 3,
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Simpan Perubahan',
//                 style:
//                     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
