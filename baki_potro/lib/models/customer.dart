class Customer {
  int customer_id;
  String customer_name;
  String customer_number;
  String customer_location;

  customerMap() {
    var mapping = Map<String, dynamic>();
    mapping['customer_id'] = customer_id;
    mapping['customer_name'] = customer_name;
    mapping['customer_number'] = customer_number;
    mapping['customer_location'] = customer_location;
    return mapping;
  }
}
