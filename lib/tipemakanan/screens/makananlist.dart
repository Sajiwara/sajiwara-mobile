import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sajiwara/tipemakanan/screens/edit_makanan.dart';
import 'package:sajiwara/tipemakanan/models/models_tipemakanan.dart';
import 'package:sajiwara/widgets/left_drawer.dart';

class MakananList extends StatefulWidget {
  const MakananList({super.key});

  @override
  State<MakananList> createState() => _MakananListState();
}

class _MakananListState extends State<MakananList> {
  List<ProductEntry> makananList = [];
  List<ProductEntry> filteredList = [];
  bool isLoading = true;
  String selectedPreferensi = "Pilih negara"; // Default value for dropdown

  final List<String> preferensiOptions = [
    "Pilih negara",
    "CHINESE",
    "INDONESIA",
    "WESTERN",
    "JAPANESE",
    "MIDDLE EASTERN"
  ];

  @override
  void initState() {
    super.initState();
    fetchMakanan();
  }

  Future<void> fetchMakanan() async {
    try {
      final response = await http.get(Uri.parse(
          'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/tipemakanan/json/'));
      // 'https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/tipemakanan/json/')); // URL API
      if (response.statusCode == 200) {
        setState(() {
          makananList = productEntryFromJson(response.body);
          filteredList = makananList; // Default: tampilkan semua makanan
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

  void filterMakanan(String preferensi) {
    setState(() {
      if (preferensi == "Pilih negara") {
        filteredList =
            List.from(makananList); // Tampilkan semua jika default dipilih
      } else {
        filteredList = makananList
            .where((makanan) =>
                makanan.fields.preferensi.toString().split('.').last ==
                preferensi)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore Makanan',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for filtering
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedPreferensi,
                    items: preferensiOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPreferensi = value!;
                        filterMakanan(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Pilih Preferensi Negara',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => filterMakanan(selectedPreferensi),
                  child: const Text("Cari"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final makanan = filteredList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  makanan.fields.restoran,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Teks preferensi dengan titik dua
                                Text(
                                  "Preferensi: ${makanan.fields.preferensi.toString().split('.').last}",
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      makanan.fields.menu,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditMakanan(
                                          id: makanan.pk,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
