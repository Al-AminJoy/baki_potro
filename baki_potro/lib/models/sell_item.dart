class Sell {
  int sell_id;
  String customer_name;
  double amount;
  int bill_type;
  String date;
  int customer_id;
  String description;
  String category;

  sellMapping() {
    var mapping = Map<String, dynamic>();
    mapping['sell_id'] = sell_id;
    mapping['customer_name'] = customer_name;
    mapping['amount'] = amount;
    mapping['bill_type'] = bill_type;
    mapping['date'] = date;
    mapping['customer_id'] = customer_id;
    mapping['description'] = description;
    mapping['category'] = category;
    return mapping;
  }
}
