class Supplier {
  int supplier_id;
  String supplier_name;
  String supplier_number;
  String supplier_location;

  supplierMap() {
    var mapping = Map<String, dynamic>();
    mapping['supplier_id'] = supplier_id;
    mapping['supplier_name'] = supplier_name;
    mapping['supplier_number'] = supplier_number;
    mapping['supplier_location'] = supplier_location;
    return mapping;
  }
}
