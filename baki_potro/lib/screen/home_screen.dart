import 'package:baki_potro/models/buy_items.dart';
import 'package:baki_potro/models/sell_item.dart';
import 'package:baki_potro/service/buy_service.dart';
import 'package:baki_potro/service/sell_service.dart';
import 'package:baki_potro/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
///Graph Components
class Sales {
  int day;
  double salesval;

  Sales(this.day, this.salesval);
}
///Added Mixin for tab controls
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _sell_service = SellService();
  List<Sell> _sell_list = [];
  var _buy_service = BuyService();
  List<Buy> _buy_list = [];
  List<Sales> _graph_sell_list = [];

  double _total_buy = 0.0;
  double _total_sell = 0.0;
  double _todays_total_buy = 0.0;
  double _todays_total_sell = 0.0;
  DateTime now = new DateTime.now();
  List<charts.Series<Sales, int>> _seriesLineData;
///wait for graph animation
  justWait() async {
    await Future.delayed(Duration(milliseconds: 600));
    // return 1;
  }

  @override
  void initState() {
    _get_sells();
    _get_buys();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }
///generate sells graph data
  _generateData() {
    var linesalesdata = _graph_sell_list;
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Sales',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.day,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }
///Getting sells data
  _get_sells() async {
    String todaysDate = DateFormat('yyyy-MM-dd').format(now);
    List sells = await _sell_service.readSell();
    int day = int.parse(todaysDate.substring(8));
    double amount7 = 0.0;
    double amount6 = 0.0;
    double amount5 = 0.0;
    double amount4 = 0.0;
    double amount3 = 0.0;
    double amount2 = 0.0;
    double amount1 = 0.0;

    sells.reversed.forEach((sell) {
      setState(() {
        var model = Sell();
        model.sell_id = sell['sell_id'];
        model.customer_id = sell['customer_id'];
        model.customer_name = sell['customer_name'];
        model.bill_type = sell['bill_type'];
        model.amount = sell['amount'];
        model.date = sell['date'];
        _total_sell += sell['amount'];
        int model_date = int.parse(sell['date'].substring(8));
       ///getting daily sell amount
        if (model_date == day) {
          amount7 += sell['amount'];
        } else if (model_date == (day - 1)) {
          amount6 += sell['amount'];
        } else if (model_date == (day - 2)) {
          amount5 += sell['amount'];
        } else if (model_date == (day - 3)) {
          amount4 += sell['amount'];
        } else if (model_date == (day - 4)) {
          amount3 += sell['amount'];
        } else if (model_date == (day - 5)) {
          amount2 += sell['amount'];
        } else if (model_date == (day - 6)) {
          amount1 += sell['amount'];
        }

        if (todaysDate == sell['date']) {
          _sell_list.add(model);
          _todays_total_sell += sell['amount'];
        }
      });
    });
    ///generating graph sell list
    setState(() {
      _graph_sell_list.add(new Sales(7, amount7));
      _graph_sell_list.add(new Sales(6, amount6));
      _graph_sell_list.add(new Sales(5, amount5));
      _graph_sell_list.add(new Sales(4, amount4));
      _graph_sell_list.add(new Sales(3, amount3));
      _graph_sell_list.add(new Sales(2, amount2));
      _graph_sell_list.add(new Sales(1, amount1));
    });
  }
///getting buy data
  _get_buys() async {
    String todaysDate = DateFormat('yyyy-MM-dd').format(now);
    List buys = await _buy_service.readBuy();
    buys.forEach((buy) {
      setState(() {
        var model = Buy();
        model.buy_id = buy['buy_id'];
        model.supplier_id = buy['supplier_id'];
        model.supplier_name = buy['supplier_name'];
        model.bill_type = buy['bill_type'];
        model.amount = buy['amount'];
        model.date = buy['date'];
        _total_buy += buy['amount'];
        if (todaysDate == buy['date']) {
          _buy_list.add(model);
          _todays_total_buy += buy['amount'];
        }
      });
    });
  }
///show sell list widget
  show_sell_list(index) {
    if (_sell_list[index].bill_type == 1) {
      return ListTile(
        leading: new Text(_sell_list[index].customer_name),
        title: Center(
          child: new Text('${_sell_list[index].amount}'),
        ),
        trailing: new Text(
          'নগদ',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      );
    } else {
      return ListTile(
        leading: new Text(_sell_list[index].customer_name),
        title: Center(
          child: new Text('${_sell_list[index].amount}'),
        ),
        trailing: new Text(
          'বাকি',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
  }
  ///show buy list widget
  show_buy_list(index) {
    if (_buy_list[index].bill_type == 1) {
      return ListTile(
        leading: new Text(_buy_list[index].supplier_name),
        title: Center(
          child: new Text('${_buy_list[index].amount}'),
        ),
        trailing: new Text(
          'নগদ',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      );
    } else {
      return ListTile(
        leading: new Text(_buy_list[index].supplier_name),
        title: Center(
          child: new Text('${_buy_list[index].amount}'),
        ),
        trailing: new Text(
          'বাকি',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
                //   color: Theme.of(context).cardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: new Text(
                            'সর্বমোট হিসাব',
                            style: new TextStyle(
                                //color: Common.textBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: new Text(
                            'আয় : ${_total_sell}',
                            style: new TextStyle(
                              // color: Common.textBlackColor,
                              fontSize: 14,
                            ),
                          ),
                          trailing: new Text(
                            'ব্যয় : ${_total_buy} ',
                            style: new TextStyle(
                              // color: Common.textBlackColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ))),
            Card(
                //  color: Common.whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: new Text(
                            'আজকের হিসাব',
                            style: new TextStyle(
                                //   color: Common.textBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: new Text(
                            'আয় : ${_todays_total_sell}',
                            style: new TextStyle(
                              //   color: Common.textBlackColor,
                              fontSize: 14,
                            ),
                          ),
                          trailing: new Text(
                            'ব্যয় : ${_todays_total_buy} ',
                            style: new TextStyle(
                              // color: Common.textBlackColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ))),
            ///show graph
            Card(
              // color: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                //color: Colors.black26,
                height: 150,
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'গত ৭ দিনের আয়ের চিত্রলেখ',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: justWait(),
                          builder: (context, snapshot) {
                            return charts.LineChart(_seriesLineData,
                                defaultRenderer: new charts.LineRendererConfig(
                                    includeArea: true, stacked: true),
                                animate: false,
                                animationDuration: Duration(seconds: 3),
                                behaviors: [
                                  new charts.ChartTitle('দিন',
                                      behaviorPosition:
                                          charts.BehaviorPosition.bottom,
                                      titleOutsideJustification: charts
                                          .OutsideJustification.middleDrawArea),
                                  new charts.ChartTitle('টাকা',
                                      behaviorPosition:
                                          charts.BehaviorPosition.start,
                                      titleOutsideJustification: charts
                                          .OutsideJustification.middleDrawArea),
                                  new charts.ChartTitle(
                                    'আয়',
                                    behaviorPosition:
                                        charts.BehaviorPosition.end,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea,
                                  )
                                ]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ///show tab
            Container(
                child: Card(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Common.whiteColor,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.attach_money),
                    text: 'আজকের আয়',
                  ),
                  Tab(
                    icon: Icon(Icons.shopping_cart),
                    text: 'আজকের ব্যয়',
                  )
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
                        itemCount: _sell_list.length,
                        itemBuilder: (context, index) {
                          return show_sell_list(index);
                        }),
                  )),
                  Container(
                      child: Card(
                    //color: Common.whiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: ListView.builder(
                        itemCount: _buy_list.length,
                        itemBuilder: (context, index) {
                          return show_buy_list(index);
                        }),
                  ))
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
