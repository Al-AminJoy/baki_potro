class Product {
  int product_id;
  String product_name;
  double price;
  double quantity;
  String category;

  productMapping() {
    var mapping = Map<String, dynamic>();
    mapping['product_id'] = product_id;
    mapping['product_name'] = product_name;
    mapping['price'] = price;
    mapping['quantity'] = quantity;
    mapping['category'] = category;
    return mapping;
  }
}
