List<Map<String, dynamic>> filterTrees(
  List<Map<String, dynamic>> trees,
  String selectedType,
  String searchQuery,
) {
  return trees.where((tree) {
    bool matchesType = selectedType == "All" || tree['type'] == selectedType;
    bool matchesSearch =
        tree['name'].toLowerCase().contains(searchQuery.toLowerCase());
    return matchesType && matchesSearch;
  }).toList();
}
