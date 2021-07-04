import 'package:baki_potro/models/sell_item.dart';
import 'package:baki_potro/service/category_service.dart';
import 'package:baki_potro/service/customer_service.dart';
import 'package:baki_potro/service/sell_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddSell extends StatefulWidget {
  @override
  _AddSellState createState() => _AddSellState();
}

class _AddSellState extends State<AddSell> {
  var _selectedValue;
  var _customers = List<DropdownMenuItem>();
  int _radioValue = 1;
  String _customer_name = '';
  int _customer_id;
  var _price_controller = TextEditingController();
  var _sellService = SellService();
  var _selectedCategoryValue;
  var _categories = List<DropdownMenuItem>();
  var _description_controller = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _showSnackBar(message) {
    var snackBar = new SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadCategories();
  }
///loading categories
  void _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: new Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }
///loading customers
  void _loadCustomers() async {
    var _customerService = CustomerService();
    var customers = await _customerService.readCustomer();
    customers.forEach((customer) {
      setState(() {
        _customers.add(DropdownMenuItem(
          child: Text(
              '${customer['customer_name']} (${customer['customer_number']})'),
          value: customer['customer_id'],
          onTap: () {
            setState(() {
              _customer_name = customer['customer_name'];
              _customer_id = customer['customer_id'];
              print('Customer Name' + _customer_name);
            });
          },
        ));
      });
    });
  }
///insert sell in local database
  _addSell() async {
    // print('Selected Value Is : ${_selectedValue}');
    if (_price_controller.text != '') {
      if (_selectedValue != null) {
        double price = double.parse(_price_controller.text);
        DateTime now = new DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        var sell_list = [];
        Sell sell = Sell();
        sell.customer_id = _customer_id;
        sell.customer_name = _customer_name;
        sell.amount = price;
        sell.bill_type = _radioValue;
        sell.date = formattedDate;
        sell.description = _description_controller.text;
        sell.category = _selectedCategoryValue;
        sell_list.add(sell);
        var result = await _sellService.saveSell(sell);
        print(result);
        if (result != null) {
          _price_controller.clear();
          _showSnackBar(new Text('সফল'));
        } else {
          _showSnackBar(new Text('ব্যর্থ'));
        }
      } else {
        _showSnackBar(new Text('ক্রেতা নির্বাচন করুন'));
      }
    } else {
      _showSnackBar(new Text('টাকার পরিমাণ যোগ করুন'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: new AppBar(
        title: new Text('বিক্রয়'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Card(
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ক্রেতা',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      //  color: Common.textBlackColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    value: _selectedValue,
                    items: _customers,
                    hint: new Text('ক্রেতা নির্বাচন করুন'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                        print(_selectedValue);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    value: _selectedCategoryValue,
                    items: _categories,
                    hint: new Text('বিভাগ'),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryValue = value;
                        print(_selectedCategoryValue);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'বিলের ধরন',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      // color: Common.textBlackColor,
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'নগদ',
                        style: new TextStyle(fontSize: 16.0),
                      ),
                      new Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'বাকি',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                      controller: _price_controller,
                      decoration: InputDecoration(
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
                                  BorderSide(color: Colors.yellow, width: 2)),
                          filled: true,
                          hintText: 'টাকার পরিমাণ',
                          // fillColor: Colors.grey[300],
                          prefixIcon: Icon(Icons.money)),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ]),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                      controller: _description_controller,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
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
                                  BorderSide(color: Colors.yellow, width: 2)),
                          filled: true,
                          hintText: 'বিবরণ',
                          // fillColor: Colors.grey[300],
                          prefixIcon: Icon(Icons.content_paste))),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addSell,
                      child: Text('যোগ করুন'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
