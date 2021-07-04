import 'package:baki_potro/models/supplier.dart';
import 'package:baki_potro/service/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  var _nameController = TextEditingController();
  var _numberController = TextEditingController();
  var _locationController = TextEditingController();
  var _service = SupplierService();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
///adding supplier
  _addSupplier() async {
    if (_nameController.text != '') {
      if (_numberController.text != '' &&
          _numberController.text.toString().length == 11) {
        if (_locationController.text != '') {
          var supplierList = [];
          Supplier supplier = Supplier();
          supplier.supplier_name = _nameController.text;
          supplier.supplier_location = _locationController.text;
          supplier.supplier_number = _numberController.text;
          supplierList.add(supplier);
          var result = await _service.saveSupplier(supplier);
          print(result);
          if (result != null) {
            _nameController.clear();
            _locationController.clear();
            _numberController.clear();
            _showSnackBar(new Text('যুক্ত হয়েছে'));
          } else {
            _showSnackBar(new Text('ব্যর্থ হয়েছে'));
          }
        } else {
          _showSnackBar(new Text('ঠিকানা লিখুন'));
        }
      } else {
        _showSnackBar(new Text('ভুল নম্বর'));
      }
    } else {
      _showSnackBar(new Text('নাম লিখুন'));
    }
  }
///snackBar
  _showSnackBar(message) {
    var snackBar = new SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: new AppBar(
          title: new Text('সরবারহকারী যোগ করুন'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(20),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: new InputDecoration(
                              hintText: 'সরবারহকারীর নাম',
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.yellow, width: 2),
                              ),
                            ),
                            textAlign: TextAlign.start,
                            maxLength: 32,
                            style: new TextStyle(
                              fontSize: 14,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                              controller: _numberController,
                              decoration: new InputDecoration(
                                hintText: 'সরবারহকারী্র নম্বর',
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.yellow, width: 2),
                                ),
                              ),
                              textAlign: TextAlign.start,
                              style: new TextStyle(
                                fontSize: 14,
                                height: 1,
                              ),
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ]),
                          SizedBox(height: 10),
                          TextField(
                            controller: _locationController,
                            decoration: new InputDecoration(
                              hintText: 'সরবারহকারীর ঠিকানা',
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.yellow, width: 2),
                              ),
                            ),
                            maxLength: 32,
                            textAlign: TextAlign.start,
                            style: new TextStyle(
                              fontSize: 14,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _addSupplier,
                              child: new Text('যোগ করুন'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
