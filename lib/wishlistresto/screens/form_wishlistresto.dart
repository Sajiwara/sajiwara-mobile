import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/widgets/left_drawer.dart';

class WishlistRestoFormPage extends StatefulWidget {
  const WishlistRestoFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistRestoFormPageState();
}

class _WishlistRestoFormPageState extends State<WishlistRestoFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRestaurant; // Pilihan restoran yang dipilih
  List<String> _restaurants = []; // Daftar nama restoran

  @override
  void initState() {
    super.initState();
    _fetchRestaurantData();
  }

  Future<void> _fetchRestaurantData() async {
    try {
      // Membaca file JSON dari assets
      final String response = await rootBundle.loadString('restaurants.json');
      final List<dynamic> data = json.decode(response);

      // Mengambil nama restoran dari JSON
      setState(() {
        _restaurants =
            data.map((entry) => entry['Nama Restoran'] as String).toList();
      });
    } catch (e) {
      // Menangani error ketika membaca file JSON
      print('Error loading restaurant data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Tambah Restoran ke Wishlist'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedRestaurant,
                  items: _restaurants.map((restaurant) {
                    return DropdownMenuItem<String>(
                      value: restaurant,
                      child: Text(restaurant),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRestaurant = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Pilih Restoran",
                    labelText: "Restoran",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Restoran tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     // Aksi ketika tombol tambah ditekan
                    //     print('Restoran dipilih: $_selectedRestaurant');
                    //   }
                    // },

                    onPressed: () async {
                      // if (_formKey.currentState!.validate()) {
                      //   // Kirim ke Django dan tunggu respons
                      //   // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      //   final response = await request.postJson(
                      //     "http://[URL_APP_KAMU]/create-flutter/",
                      //     jsonEncode(<String, String>{
                      //       'mood': _mood,
                      //       'mood_intensity': _moodIntensity.toString(),
                      //       'feelings': _feelings,
                      //       // TODO: Sesuaikan field data sesuai dengan aplikasimu
                      //     }),
                      //   );
                      //   if (context.mounted) {
                      //     if (response['status'] == 'success') {
                      //       ScaffoldMessenger.of(context)
                      //           .showSnackBar(const SnackBar(
                      //         content: Text("Mood baru berhasil disimpan!"),
                      //       ));
                      //       Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => MyHomePage()),
                      //       );
                      //     } else {
                      //       ScaffoldMessenger.of(context)
                      //           .showSnackBar(const SnackBar(
                      //         content: Text(
                      //             "Terdapat kesalahan, silakan coba lagi."),
                      //       ));
                      //     }
                      //   }
                      // }
                    },

                    child: const Text(
                      "Tambah",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
