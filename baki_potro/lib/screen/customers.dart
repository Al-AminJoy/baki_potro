import 'package:baki_potro/models/customer.dart';
import 'package:baki_potro/service/customer_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer_details.dart';


class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var _service = CustomerService();
  List<Customer> _customer_list = [];
  List<Customer> filtered_list = [];
///loading customers
  _load_customers() async {
    List customers = await _service.readCustomer();
    customers.forEach((customer) {
      setState(() {
        var model = Customer();
        model.customer_id = customer['customer_id'];
        model.customer_name = customer['customer_name'];
        model.customer_number = customer['customer_number'];
        model.customer_location = customer['customer_location'];
        _customer_list.add(model);
      });
    });
  }

  @override
  void initState() {
    _load_customers();
    ///adding customer list in filtered list
    setState(() {
      filtered_list = _customer_list;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ক্রেতা'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(width: 2, color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(width: 2, color: Colors.transparent),
              ),
              filled: true,
              prefixIcon: Icon(Icons.search),
              hintText: 'অনুসন্ধান',
            ),
            onChanged: (value) {
              ///filtering filtered list by typing in searchfield
              setState(() {
                filtered_list = _customer_list
                    .where((element) =>
                        (element.customer_name
                            .toLowerCase()
                            .contains(value.toLowerCase())) ||
                        element.customer_number
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
                    title: Text(filtered_list[index].customer_name),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomerDetails(
                              id: filtered_list[index].customer_id)));
                    },
                    subtitle: Text(filtered_list[index].customer_number),
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
