class Car {
  final String id; // Tambahkan id
  final String name;
  final int price;
  final String color;
  final String model;
  final String imageUrl;

  Car({
    required this.id, // Terima id sebagai parameter di konstruktor
    required this.name,
    required this.price,
    required this.color,
    required this.model,
    required this.imageUrl,
  });

  // Factory method untuk mengonversi data dari Map
  factory Car.fromMap(Map<String, dynamic> data, String documentId) {
    return Car(
      id: documentId, // Simpan id dokumen
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      color: data['color'] ?? '',
      model: data['model'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
