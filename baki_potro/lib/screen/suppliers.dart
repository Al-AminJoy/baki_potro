import 'package:baki_potro/models/supplier.dart';
import 'package:baki_potro/screen/supplier_details.dart';
import 'package:baki_potro/service/supplier_service.dart';
import 'package:flutter/material.dart';

class Suppliers extends StatefulWidget {
  @override
  _SuppliersState createState() => _SuppliersState();
}

class _SuppliersState extends State<Suppliers> {
  var _service = SupplierService();
  List<Supplier> _supplier_list = [];
  List<Supplier> filtered_list = [];
///load suppliers list
  _load_supplier() async {
    List customers = await _service.readSupplier();
    customers.forEach((customer) {
      setState(() {
        var model = Supplier();
        model.supplier_id = customer['supplier_id'];
        model.supplier_name = customer['supplier_name'];
        model.supplier_number = customer['supplier_number'];
        model.supplier_location = customer['supplier_location'];
        _supplier_list.add(model);
      });
    });
  }

  @override
  void initState() {
    _load_supplier();
    setState(() {
      filtered_list = _supplier_list;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('সরবারহকারী'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          TextField(
            // controller: amount_controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(width: 2, color: Colors.transparent),
              ),
              filled: true,
              prefixIcon: Icon(Icons.search),
              hintText: 'অনুসন্ধান',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(width: 2, color: Colors.transparent),
              ),
            ),
            onChanged: (value) {
              setState(() {
                filtered_list = _supplier_list
                    .where((element) =>
                        (element.supplier_name
                            .toLowerCase()
                            .contains(value.toLowerCase())) ||
                        element.supplier_number
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered_list.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: ListTile(
                    title: Text(filtered_list[index].supplier_name),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SupplierDetails(
                              id: filtered_list[index].supplier_id)));
                    },
                    subtitle: Text(filtered_list[index].supplier_number),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
