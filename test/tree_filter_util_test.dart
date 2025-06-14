import 'package:flutter_test/flutter_test.dart';
import 'package:mobpro_deb/services/tree_filter_util.dart';

void main() {
  group('filterTrees', () {
    final trees = [
      {'name': 'Oak', 'type': 'Deciduous'},
      {'name': 'Pine', 'type': 'Conifer'},
      {'name': 'Palm', 'type': 'Tropical'},
    ];

    test('returns all trees when type is All and search is empty', () {
      final result = filterTrees(trees, 'All', '');
      expect(result.length, 3);
    });

    test('filters by type only', () {
      final result = filterTrees(trees, 'Conifer', '');
      expect(result.length, 1);
      expect(result[0]['name'], 'Pine');
    });

    test('filters by name only', () {
      final result = filterTrees(trees, 'All', 'oak');
      expect(result.length, 1);
      expect(result[0]['name'], 'Oak');
    });

    test('filters by type and name', () {
      final result = filterTrees(trees, 'Deciduous', 'oak');
      expect(result.length, 1);
      expect(result[0]['name'], 'Oak');
    });

    test('returns empty if no match', () {
      final result = filterTrees(trees, 'Tropical', 'oak');
      expect(result, isEmpty);
    });
  });
}
