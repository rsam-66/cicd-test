class Barang {
  final int? id;
  final String title;
  final String? description;
  final String? gambar;
  final int stock;
  final double harga;
  final String? createdAt;
  final String? updatedAt;

  Barang({
    this.id,
    required this.title,
    this.description,
    this.gambar,
    required this.stock,
    required this.harga,
    this.createdAt,
    this.updatedAt,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      gambar: json['gambar'] != null
          ? 'http://192.168.18.28:80${json['gambar']}'
          : null,
      stock: json['stock'] ?? 0,
      harga: double.parse((json['harga'] ?? 0).toString()),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'gambar': gambar,
      'stock': stock,
      'harga': harga,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
