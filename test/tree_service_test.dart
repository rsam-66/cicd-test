import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:mobpro_deb/services/tree_service.dart';
void main() {
  test('fetchTrees returns list of trees', () async {
    final mockClient = MockClient((request) async {
      return http.Response(jsonEncode({
        'data': [
          {
            'id': 1,
            'title': 'Oak Tree',
            'desc': 'TypeA good tree',
            'harga': 50,
            'stock': 10,
            'gambar': 'http://image.url'
          }
        ]
      }), 200);
    });

    final service = TreeService(client: mockClient);
    final trees = await service.fetchTrees();

    expect(trees, isA<List<Map<String, dynamic>>>());
    expect(trees.first['name'], 'Oak Tree');
  });
  
}
