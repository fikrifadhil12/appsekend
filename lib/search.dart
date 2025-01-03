import 'package:flutter/material.dart';
import 'lokasi.dart'; // Pastikan lokasi.dart sudah benar

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari lokasi atau tempat...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onSubmitted: (query) {
                  // Aksi saat tombol enter ditekan
                  _navigateToLokasi(context, query);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                // Aksi ketika tombol search ditekan
                _navigateToLokasi(
                    context, ""); // Atau bisa mengambil teks dari TextField
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Halaman Pencarian',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _navigateToLokasi(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarRentalScreen(query: query),
      ),
    );
  }
}
