import 'package:flutter/material.dart';
import 'carList.dart';
import 'motorList.dart';
import 'search.dart';
import 'history.dart';
import 'settings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'DASHBOARD',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile_image.jpg'), // Ganti dengan gambar profil dari assets
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tulisan promosi yang lebih menarik
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('baner1.png'), // Gambar promosi dari assets
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 20),
              ),

              // Kategori Mobil dan Motor
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Arahkan ke halaman mobil
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarListScreen()),
                      );
                    },
                    child: DashboardCard(
                        icon: Icons.directions_car, label: 'MOBIL'),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      // Arahkan ke halaman motor
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MotorListScreen()),
                      );
                    },
                    child:
                        DashboardCard(icon: Icons.motorcycle, label: 'MOTOR'),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Bagian Favorit
              _sectionTitle("Favorit"),
              _horizontalList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.wallet),
              onPressed: () {
                // Add navigation action
              },
            ),
            SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.history), // Ikon History
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(),
                  ),
                );
              },
            ),

            // Space for the floating action button
            IconButton(
              icon: Icon(Icons.settings), // Ikon History
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman pencarian ketika tombol ditekan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.navigation, color: Colors.white),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("lihat semua", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _horizontalList() {
    final List<String> contentImages = [
      'varioblack.png',
      'brv.jpg',
      'avanzablack.png',
      'avanzawhite.jpg',
      'aeroxred.png',
    ];

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(contentImages[index]), // Gambar spesifik
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                "Favorit ${index + 1}",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;

  DashboardCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 100,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.purple),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
