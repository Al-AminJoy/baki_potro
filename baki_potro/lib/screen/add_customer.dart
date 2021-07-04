import 'package:baki_potro/models/customer.dart';
import 'package:baki_potro/service/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  var _nameController = TextEditingController();
  var _numberController = TextEditingController();
  var _locationController = TextEditingController();
  var _service = CustomerService();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
///Adding Customer to local database
  _addCustomer() async {
    if (_nameController.text != '') {
      if (_numberController.text != '' &&
          (_numberController.text.toString().length) == 11) {
        if (_locationController.text != '') {
          var customerList = [];
          Customer customer = Customer();
          customer.customer_name = _nameController.text;
          customer.customer_location = _locationController.text;
          customer.customer_number = _numberController.text;
          customerList.add(customer);
          var result = await _service.saveCustomer(customer);
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
        _showSnackBar(Text('ভুল নম্বর'));
      }
    } else {
      _showSnackBar(new Text('নাম লিখুন'));
    }
  }

  _showSnackBar(message) {
    var snackBar = new SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: new AppBar(
          title: new Text('ক্রেতা যোগ করুন'),
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
                            maxLength: 32,
                            decoration: new InputDecoration(
                              hintText: 'ক্রেতার নাম',
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
                            style: new TextStyle(
                              fontSize: 14,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                              controller: _numberController,
                              maxLength: 11,
                              decoration: new InputDecoration(
                                hintText: 'ক্রেতার নম্বর',
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ]),
                          SizedBox(height: 10),
                          TextField(
                            controller: _locationController,
                            maxLength: 48,
                            decoration: new InputDecoration(
                              hintText: 'ক্রেতার ঠিকানা',
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
                              onPressed: _addCustomer,
                              child: new Text('যোগ করুন'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
