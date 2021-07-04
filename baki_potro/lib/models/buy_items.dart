class Buy {
  int buy_id;
  String supplier_name;
  double amount;
  int bill_type;
  String date;
  int supplier_id;
  String description;
  String category;

  buyMapping() {
    var mapping = Map<String, dynamic>();
    mapping['buy_id'] = buy_id;
    mapping['supplier_name'] = supplier_name;
    mapping['amount'] = amount;
    mapping['bill_type'] = bill_type;
    mapping['date'] = date;
    mapping['supplier_id'] = supplier_id;
    mapping['description'] = description;
    mapping['category'] = category;
    return mapping;
  }
}
