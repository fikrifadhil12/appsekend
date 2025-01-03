class Motor {
  final String id;
  final String name;
  final int price;
  final String color;
  final String model;
  final String imageUrl; // Properti untuk URL gambar

  Motor({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.model,
    required this.imageUrl, // Tambahkan ke konstruktor
  });

  // Factory method untuk mengonversi data dari Map
  factory Motor.fromMap(Map<String, dynamic> data, String documentId) {
    return Motor(
      id: documentId,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      color: data['color'] ?? '',
      model: data['model'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // Ambil URL gambar dari data
    );
  }
}
