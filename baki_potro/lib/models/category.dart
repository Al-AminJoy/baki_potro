class Category {
  int id;
  String name;

  categoryMap() {
    var mapping = new Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    return mapping;
  }
}
