import 'package:baki_potro/models/buy_items.dart';
import 'package:baki_potro/models/supplier.dart';
import 'package:baki_potro/service/buy_service.dart';
import 'package:baki_potro/service/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SupplierDetails extends StatefulWidget {
  int id;

  SupplierDetails({this.id});

  @override
  _SupplierDetailsState createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var amount_controller = TextEditingController();
  var _supplier_service = SupplierService();
  var _buy_service = BuyService();
  Supplier _supplier = Supplier();
  List<Buy> _buy_list_due = [];
  List<Buy> _buy_list_paid = [];
  double _total_due = 0.0;
  double _total_paid = 0.0;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
///show toast
  show_toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }
///find supplier from local database by passing id
  _find_supplier() async {
    var supplier = await _supplier_service.readSupplierByID(this.widget.id);
    setState(() {
      _supplier.supplier_id = supplier[0]['supplier_id'];
      _supplier.supplier_name = supplier[0]['supplier_name'];
      _supplier.supplier_number = supplier[0]['supplier_number'];
      _supplier.supplier_location = supplier[0]['supplier_location'];
    });
  }
///get suppliers sell information
  _get_suppliers_data() async {
    List buys =
        await _buy_service.readBuyByColumn('supplier_id', this.widget.id);

    buys.reversed.forEach((buy) {
      setState(() {
        var model = Buy();
        model.buy_id = buy['buy_id'];
        model.supplier_name = buy['supplier_name'];
        model..supplier_id = buy['supplier_id'];
        model.bill_type = buy['bill_type'];
        model.amount = buy['amount'];
        model.date = buy['date'];
        model.description = buy['description'];
        model.category = buy['description'];
        if (buy['bill_type'] == 0) {
          _buy_list_due.add(model);
          _total_due += buy['amount'];
        } else {
          _buy_list_paid.add(model);
          _total_paid += buy['amount'];
        }
      });
    });
  }

  show_snack_bar(message) {
    var snackbar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackbar);
  }
///edit dialog for edit data
  _show_edit_dialog(Buy updateBuy, BuildContext context) async {
    var buy = await _buy_service.readBuyByID(updateBuy.buy_id);
    setState(() {
      amount_controller.text = buy[0]['amount'].toString();
    });
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: new Text(
              'বিল সম্পাদনা করুন',
              style: TextStyle(fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: amount_controller,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(width: 2, color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(width: 2, color: Colors.yellow),
                      ),
                      prefixIcon: Icon(Icons.attach_money_rounded),
                      hintText: 'টাকার পরিমাণ',
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var result = await _buy_service.deleteBuy(updateBuy.buy_id);
                    if (result != null) {
                      _buy_list_due.clear();
                      _buy_list_paid.clear();
                      amount_controller.clear();
                      _total_due = 0.0;
                      _total_paid = 0.0;
                      _get_suppliers_data();
                      Navigator.pop(context);
                      show_snack_bar(new Text('মুছে ফেলা হয়েছে'));
                    } else {
                      show_snack_bar(new Text('ব্যর্থ'));
                    }
                  },
                  child: Text('হিসেব মুছে ফেলুন'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (amount_controller.text != '') {
                        double updatedAmount =
                            double.parse(amount_controller.text);
                        if (updatedAmount <= 0) {
                          show_toast('১ টাকার কম টাকা হলে মুছে ফেলুন');
                        } else {
                          updateBuy.amount = updatedAmount;
                          var result = await _buy_service.updateBuy(updateBuy);
                          print(result);
                          if (result != null) {
                            _buy_list_due.clear();
                            _buy_list_paid.clear();
                            _total_due = 0.0;
                            _total_paid = 0.0;
                            _get_suppliers_data();
                            amount_controller.clear();
                            Navigator.pop(context);
                            show_snack_bar(new Text('হালনাগাদ হয়েছে'));
                          } else {
                            show_snack_bar(new Text('ব্যর্থ'));
                          }
                        }
                      } else {
                        show_snack_bar(new Text('অবৈধ টাকার পরিমাণ'));
                      }
                    },
                    child: Text('হালনাগাদ')),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _find_supplier();
    _get_suppliers_data();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('বিক্রেতার বিবরণ'),
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${_supplier.supplier_name}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${_supplier.supplier_number}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${_supplier.supplier_location}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.cyan,
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                      child: Text(
                                    'মোট ক্রয় : ${_total_due + _total_paid} টাকা',
                                    style: TextStyle(fontSize: 16),
                                  )),
                                ),
                                Row(mainAxisSize: MainAxisSize.max, children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.green,
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('নগদ'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('$_total_paid'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.red,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('বাকি'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text('$_total_due'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.money),
                        text: 'নগদ',
                      ),
                      Tab(
                        icon: Icon(Icons.money_off),
                        text: 'বাকি',
                      ),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                )),
                Expanded(
                    child: TabBarView(
                  children: [
                    Container(
                        child: Card(
                      //color: Common.whiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: ListView.builder(
                          itemCount: _buy_list_paid.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                        Text('${_buy_list_paid[index].date}'),
                                    title: Center(
                                        child: Text(
                                            '${_buy_list_paid[index].amount} Tk')),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Buy update = Buy();
                                        update.buy_id =
                                            _buy_list_paid[index].buy_id;
                                        update.date =
                                            _buy_list_paid[index].date;
                                        update.supplier_name =
                                            _buy_list_paid[index].supplier_name;
                                        update.amount =
                                            _buy_list_paid[index].amount;
                                        update.bill_type =
                                            _buy_list_paid[index].bill_type;
                                        update.supplier_id =
                                            _buy_list_paid[index].supplier_id;
                                        update.description =
                                            _buy_list_paid[index].description;
                                        update.category =
                                            _buy_list_paid[index].category;
                                        _show_edit_dialog(update, context);
                                      },
                                    ),
                                    //  subtitle: Text('${_sell_list_paid[index].customer_name}'),
                                  ),
                                  Container(
                                    height: 2,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                          }),
                    )),
                    Container(
                        child: Card(
                      //color: Common.whiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: ListView.builder(
                          itemCount: _buy_list_due.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                        Text('${_buy_list_due[index].date}'),
                                    title: Center(
                                        child: Text(
                                            '${_buy_list_due[index].amount} Tk')),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Buy update = Buy();
                                        update.buy_id =
                                            _buy_list_due[index].buy_id;
                                        update.date = _buy_list_due[index].date;
                                        update.supplier_name =
                                            _buy_list_due[index].supplier_name;
                                        update.amount =
                                            _buy_list_due[index].amount;
                                        update.bill_type =
                                            _buy_list_due[index].bill_type;
                                        update.supplier_id =
                                            _buy_list_due[index].supplier_id;
                                        update.description =
                                            _buy_list_due[index].description;
                                        update.category =
                                            _buy_list_due[index].category;
                                        _show_edit_dialog(update, context);
                                      },
                                    ),
                                    //  subtitle: Text('${_sell_list_paid[index].customer_name}'),
                                  ),
                                  Container(
                                    height: 2,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                          }),
                    ))
                  ],
                  controller: _tabController,
                ))
              ],
            )));
  }
}
