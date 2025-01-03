import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mobil.dart';
import 'paymentScreen.dart'; // Mengimpor halaman PaymentScreen

class BookingMobilScreen extends StatefulWidget {
  final String carId; // ID mobil yang dipilih dari Firebase

  BookingMobilScreen({required this.carId});

  @override
  _BookingMobilScreenState createState() => _BookingMobilScreenState();
}

class _BookingMobilScreenState extends State<BookingMobilScreen> {
  int jumlah = 1; // Jumlah mobil
  DateTime? startDate; // Tanggal awal
  DateTime? endDate; // Tanggal akhir

  Future<void> _pickDate({required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (startDate ?? DateTime.now())
          : (endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          if (endDate != null && picked.isAfter(endDate!)) {
            endDate = null; // Reset tanggal akhir jika tanggal awal diperbarui
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<Car> getCarData() async {
    // Mengambil data mobil dari Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .doc(widget.carId)
        .get();

    // Mengonversi data Firestore menjadi objek Car
    return Car.fromMap(snapshot.data() as Map<String, dynamic>, widget.carId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "BOOKING MOBIL",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Car>(
        future: getCarData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          final car = snapshot.data!;
          int totalHari = startDate != null && endDate != null
              ? endDate!.difference(startDate!).inDays + 1
              : 0;
          int totalHarga = jumlah * totalHari * car.price;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Image.network(
                  car.imageUrl, // Gambar mobil
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 80);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  car.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Jumlah"),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (jumlah > 1) jumlah--;
                                  });
                                },
                              ),
                              Text(jumlah.toString().padLeft(2, '0')),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    jumlah++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tanggal Mulai"),
                          TextButton(
                            onPressed: () => _pickDate(isStartDate: true),
                            child: Text(
                              startDate == null
                                  ? "Pilih Tanggal"
                                  : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tanggal Selesai"),
                          TextButton(
                            onPressed: startDate == null
                                ? null
                                : () => _pickDate(isStartDate: false),
                            child: Text(
                              endDate == null
                                  ? "Pilih Tanggal"
                                  : "${endDate!.day}/${endDate!.month}/${endDate!.year}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      if (totalHari > 0) const SizedBox(height: 16),
                      if (totalHari > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Hari"),
                            Text(
                              "$totalHari Hari",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Harga"),
                          Text(
                            totalHari > 0
                                ? "Rp ${totalHarga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}"
                                : "-",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: startDate != null && endDate != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  totalHarga: totalHarga,
                                  carName: car.name,
                                  motorName: '',
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      "CHECK OUT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
