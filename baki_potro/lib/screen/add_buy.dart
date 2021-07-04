import 'package:baki_potro/models/buy_items.dart';
import 'package:baki_potro/service/buy_service.dart';
import 'package:baki_potro/service/category_service.dart';
import 'package:baki_potro/service/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBuy extends StatefulWidget {
  @override
  _AddBuyState createState() => _AddBuyState();
}

class _AddBuyState extends State<AddBuy> {
  var _selectedValue;
  var _suppliers = List<DropdownMenuItem>();
  var _selectedCategoryValue;
  var _categories = List<DropdownMenuItem>();
  int _radioValue = 1;
  String _supplier_name = '';
  int _supplier_id;
  var _price_controller = TextEditingController();
  var _description_controller = TextEditingController();
  var _buyService = BuyService();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
///SnackBar
  _showSnackBar(message) {
    var snackBar = new SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }
///Change Radio Button Value
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _loadCategories();
  }
///Loading Categories from local database
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
///loading suppliers from local database
  void _loadSuppliers() async {
    var _supplierService = SupplierService();
    var suppliers = await _supplierService.readSupplier();
    suppliers.forEach((supplier) {
      setState(() {
        _suppliers.add(DropdownMenuItem(
          child: Text(
              '${supplier['supplier_name']} (${supplier['supplier_number']})'),
          value: supplier['supplier_id'],
          onTap: () {
            setState(() {
              _supplier_name = supplier['supplier_name'];
              _supplier_id = supplier['supplier_id'];
              //print('Supplier Name '+_supplier_name);
            });
          },
        ));
      });
    });
  }
///insert buy to local database
  _addBuy() async {
    if (_price_controller.text != '') {
      if (_selectedValue != null) {
        double price = double.parse(_price_controller.text);
        DateTime now = new DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        var buy_list = [];
        Buy buy = Buy();
        buy.supplier_id = _supplier_id;
        buy.supplier_name = _supplier_name;
        buy.amount = price;
        buy.bill_type = _radioValue;
        buy.date = formattedDate;
        buy.description = _description_controller.text;
        buy.category = _selectedCategoryValue;
        buy_list.add(buy);
        var result = await _buyService.saveBuy(buy);
        print(result);
        if (result != null) {
          _price_controller.clear();
          _showSnackBar(new Text('সফল'));
        } else {
          _showSnackBar(new Text('ব্যর্থ'));
        }
      } else {
        _showSnackBar(new Text('সরবরাহকারী নির্বাচন করুন'));
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
        title: new Text('ক্রয়'),
      ),
      body: Container(
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
                  'সরবরাহকারী',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    // color: Common.textBlackColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  value: _selectedValue,
                  items: _suppliers,
                  hint: new Text('সরবরাহকারী নির্বাচন করুন'),
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
                TextField(
                  controller: _price_controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2)),
                      filled: true,
                      hintText: 'টাকার পরিমাণ',
                      // fillColor: Colors.grey[300],
                      prefixIcon: Icon(Icons.money)),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                    controller: _description_controller,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.green, width: 2),
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
                      onPressed: _addBuy,
                      child: Text('যোগ করুন'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                      )),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
