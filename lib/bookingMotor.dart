import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'motor.dart';
import 'paymentScreen.dart';

class BookingMotorScreen extends StatefulWidget {
  final String motorId; // ID motor yang dipilih

  BookingMotorScreen({required this.motorId});

  @override
  _BookingMotorScreenState createState() => _BookingMotorScreenState();
}

class _BookingMotorScreenState extends State<BookingMotorScreen> {
  int jumlah = 1;
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
          // Reset endDate jika startDate diubah
          if (endDate != null && picked.isAfter(endDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<Motor> getMotorData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('motor')
        .doc(widget.motorId)
        .get();

    return Motor.fromMap(
        snapshot.data() as Map<String, dynamic>, widget.motorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "BOOKING MOTOR",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Motor>(
        future: getMotorData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Data tidak ditemukan.'));
          }

          final motor = snapshot.data!;
          int totalHari = startDate != null && endDate != null
              ? endDate!.difference(startDate!).inDays + 1
              : 0;
          int totalHarga = jumlah * totalHari * motor.price;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                Image.network(
                  motor.imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 80);
                  },
                ),
                SizedBox(height: 16),
                Text(
                  motor.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
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
                          Text("Jumlah"),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (jumlah > 1) jumlah--;
                                  });
                                },
                              ),
                              Text(jumlah.toString().padLeft(2, '0')),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
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
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tanggal Mulai"),
                          TextButton(
                            onPressed: () => _pickDate(isStartDate: true),
                            child: Text(
                              startDate == null
                                  ? "Pilih Tanggal"
                                  : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tanggal Selesai"),
                          TextButton(
                            onPressed: startDate == null
                                ? null
                                : () => _pickDate(isStartDate: false),
                            child: Text(
                              endDate == null
                                  ? "Pilih Tanggal"
                                  : "${endDate!.day}/${endDate!.month}/${endDate!.year}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      if (totalHari > 0) SizedBox(height: 16),
                      if (totalHari > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Hari"),
                            Text(
                              "$totalHari Hari",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Harga"),
                          Text(
                            totalHari > 0
                                ? "Rp ${totalHarga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}"
                                : "-",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
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
                                  motorName: motor.name,
                                  carName: '',
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      "CHECK OUT",
                      style: TextStyle(
                        fontSize: 16,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
