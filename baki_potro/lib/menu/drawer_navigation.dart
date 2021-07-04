import 'dart:typed_data';

import 'package:baki_potro/screen/add_buy.dart';
import 'package:baki_potro/screen/add_category.dart';
import 'package:baki_potro/screen/add_customer.dart';
import 'package:baki_potro/screen/add_sell.dart';
import 'package:baki_potro/screen/add_supplier.dart';
import 'package:baki_potro/screen/customers.dart';
import 'package:baki_potro/screen/suppliers.dart';
import 'package:baki_potro/utils/shared_preference.dart';
import 'package:baki_potro/utils/utility.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  Uint8List _imageFromPreferences = null;
  String _name = 'নাম সেট করা হয়নি';
  String _number = 'নম্বর সেট করা হয়নি';

  @override
  void initState() {
    _sharedPrefData();
    super.initState();
  }
///show user image
  _show_image() {
    if (_imageFromPreferences != null) {
      return Center(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Image.memory(
          _imageFromPreferences,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ));
    } else {
      return Center(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Utility.circularEmptyImage(),
      ));
    }
  }
///load shared preference data
  _sharedPrefData() {
    SharedPref.getFromPreferences(SharedPref.IMAGE_KEY).then((img) {
      if (img == null) {
        return;
      }
      setState(() {
        _imageFromPreferences = Utility.dataFromBase64String(img);
      });
    });
    SharedPref.getFromPreferences(SharedPref.NAME_KEY).then((name) {
      if (name == null) {
        return;
      }
      setState(() {
        _name = name;
      });
    });
    SharedPref.getFromPreferences(SharedPref.NUMBER_KEY).then((number) {
      if (number == null) {
        return;
      }
      setState(() {
        _number = number;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Drawer(
        child: new ListView(
          children: [
            new UserAccountsDrawerHeader(
              accountName: Text(_name),
              accountEmail: Text(_number),
              currentAccountPicture: _show_image(),
              decoration: new BoxDecoration(color: Colors.green),
            ),
            new ListTile(
              leading: Icon(Icons.home),
              title: new Text('হোম'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => new Navigation())),
            ),
            new ListTile(
              leading: Icon(Icons.view_list),
              title: new Text('বিভাগ যোগ করুন'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => new AddCategory())),
            ),
            new ListTile(
              leading: Icon(Icons.person),
              title: new Text('ক্রেতা'),
              onTap: () => Navigator.of(context)
                  .push(
                      MaterialPageRoute(builder: (context) => new Customers()))
                  .whenComplete(() => initState()),
            ),
            new ListTile(
              leading: Icon(Icons.analytics_rounded),
              title: new Text('সরবরাহকারী'),
              onTap: () => Navigator.of(context)
                  .push(
                      MaterialPageRoute(builder: (context) => new Suppliers()))
                  .whenComplete(() => initState()),
            ),
            new ListTile(
              leading: Icon(Icons.person_add_alt),
              title: new Text('ক্রেতা যুক্ত করুন'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => new AddCustomer())),
            ),
            new ListTile(
              leading: Icon(Icons.people_sharp),
              title: new Text('সরবরাহকারী যুক্ত করুন'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => new AddSupplier())),
            ),
            new ListTile(
              leading: Icon(Icons.shopping_cart),
              title: new Text('ক্রয় যুক্ত করুন'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => new AddBuy()))
                  .whenComplete(() => initState()),
            ),
            new ListTile(
              leading: Icon(Icons.attach_money),
              title: new Text('বিক্রয় যুক্ত করুন'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => new AddSell()))
                  .whenComplete(() => initState()),
            ),
          ],
        ),
      ),
    );
  }
}
