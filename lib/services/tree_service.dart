import 'package:http/http.dart' as http;
import 'dart:convert';

class TreeService {
  final http.Client client;

  TreeService({required this.client});

  Future<List<Map<String, dynamic>>> fetchTrees() async {
    final response = await client.get(Uri.parse('http://localhost:3000/api/pohon'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((tree) => {
            "id": tree['id'],
            "name": tree['title'],
            "type": tree['desc'].split(' ')[0],
            "price": double.parse(tree['harga'].toString()),
            "stock": tree['stock'],
            "image": tree['gambar']
          }).toList();
    } else {
      throw Exception('Failed to load trees');
    }
  }
}
