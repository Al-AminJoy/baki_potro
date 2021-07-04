import 'package:baki_potro/models/customer.dart';
import 'package:baki_potro/models/sell_item.dart';
import 'package:baki_potro/service/customer_service.dart';
import 'package:baki_potro/service/sell_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CustomerDetails extends StatefulWidget {
  final int id;

  CustomerDetails({this.id});

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}
///Added Mixin for TabBar
class _CustomerDetailsState extends State<CustomerDetails>
    with SingleTickerProviderStateMixin {
  ///tabController for control the tab state
  TabController _tabController;
  var amount_controller = TextEditingController();
  var _customer_service = CustomerService();
  var _sell_service = SellService();
  Customer _customer = Customer();
  List<Sell> _sell_list_due = [];
  List<Sell> _sell_list_paid = [];
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
///find customer by passing id
  _find_customer() async {
    var customer = await _customer_service.readCustomerByID(this.widget.id);
    setState(() {
      _customer.customer_id = customer[0]['customer_id'];
      _customer.customer_name = customer[0]['customer_name'];
      _customer.customer_number = customer[0]['customer_number'];
      _customer.customer_location = customer[0]['customer_location'];
    });
  }
///loading customers data from local database
  _get_customers_data() async {
    List sells =
        await _sell_service.readSellByColumn('customer_id', this.widget.id);
    sells.reversed.forEach((sell) {
      setState(() {
        var model = Sell();
        model.sell_id = sell['sell_id'];
        model.customer_name = sell['customer_name'];
        model..customer_id = sell['customer_id'];
        model.bill_type = sell['bill_type'];
        model.amount = sell['amount'];
        model.date = sell['date'];
        model.category = sell['category'];
        model.description = sell['description'];
        if (sell['bill_type'] == 0) {
          _sell_list_due.add(model);
          _total_due += sell['amount'];
        } else {
          _sell_list_paid.add(model);
          _total_paid += sell['amount'];
        }
      });
    });
  }

  show_snack_bar(message) {
    var snackbar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackbar);
  }
///show dialog when edit option clicked
  _show_edit_dialog(Sell updateSell, BuildContext context) async {
    //  var sell=Sell();
    var sell = await _sell_service.readSellByID(updateSell.sell_id);
    setState(() {
      amount_controller.text = sell[0]['amount'].toString();
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
                    var result =
                        await _sell_service.deleteSell(updateSell.sell_id);
                    if (result != null) {
                      _sell_list_due.clear();
                      _sell_list_paid.clear();
                      amount_controller.clear();
                      _total_due = 0.0;
                      _total_paid = 0.0;
                      _get_customers_data();
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
                          updateSell.amount = updatedAmount;
                          var result =
                              await _sell_service.updateSell(updateSell);
                          print(result);
                          if (result != null) {
                            _sell_list_due.clear();
                            _sell_list_paid.clear();
                            _total_due = 0.0;
                            _total_paid = 0.0;
                            _get_customers_data();
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
    _find_customer();
    _get_customers_data();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('ক্রেতার বিবরণ'),
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
                            '${_customer.customer_name}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${_customer.customer_number}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${_customer.customer_location}',
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
                                    'মোট বিক্রয় : ${_total_due + _total_paid} টাকা',
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
                          itemCount: _sell_list_paid.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                        Text('${_sell_list_paid[index].date}'),
                                    title: Center(
                                        child: Text(
                                            '${_sell_list_paid[index].amount} Tk')),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Sell update = Sell();
                                        update.sell_id =
                                            _sell_list_paid[index].sell_id;
                                        update.date =
                                            _sell_list_paid[index].date;
                                        update.customer_name =
                                            _sell_list_paid[index]
                                                .customer_name;
                                        update.amount =
                                            _sell_list_paid[index].amount;
                                        update.bill_type =
                                            _sell_list_paid[index].bill_type;
                                        update.customer_id =
                                            _sell_list_paid[index].customer_id;
                                        update.description =
                                            _sell_list_paid[index].description;
                                        update.category =
                                            _sell_list_paid[index].category;
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
                          itemCount: _sell_list_due.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                        Text('${_sell_list_due[index].date}'),
                                    title: Center(
                                        child: Text(
                                            '${_sell_list_due[index].amount} Tk')),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Sell update = Sell();
                                        update.sell_id =
                                            _sell_list_due[index].sell_id;
                                        update.date =
                                            _sell_list_due[index].date;
                                        update.customer_name =
                                            _sell_list_due[index].customer_name;
                                        update.amount =
                                            _sell_list_due[index].amount;
                                        update.bill_type =
                                            _sell_list_due[index].bill_type;
                                        update.customer_id =
                                            _sell_list_due[index].customer_id;
                                        update.description =
                                            _sell_list_due[index].description;
                                        update.category =
                                            _sell_list_due[index].category;
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
