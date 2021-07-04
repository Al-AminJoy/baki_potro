import 'dart:typed_data';

import 'package:baki_potro/screen/update_profile.dart';
import 'package:baki_potro/utils/common.dart';
import 'package:baki_potro/utils/shared_preference.dart';
import 'package:baki_potro/utils/utility.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Image _imageFromPreferences = Utility.circularEmptyImage();
  String _name;
  String _email;
  String _number;

  @override
  void initState() {
    setState(() {
      _loadDataFromPreferences();
    });
  }
///load user data from shared preference
  _loadDataFromPreferences() {
    SharedPref.getFromPreferences(SharedPref.IMAGE_KEY).then((img) {
      if (img == null) {
        return;
      }
      setState(() {
        _imageFromPreferences = Utility.circularImageFromBase64String(img);
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
    SharedPref.getFromPreferences(SharedPref.EMAIL_KEY).then((email) {
      if (email == null) {
        return;
      }
      setState(() {
        _email = email;
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 80, bottom: 20),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'নাম',
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            color: Common.darkGreyColor,
                            width: double.infinity,
                            height: 1,
                            margin: EdgeInsets.all(10),
                          ),
                          _name != null ? Text(_name) : Text('যোগ করা হয়নি'),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'ইমেইল',
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            color: Common.darkGreyColor,
                            width: double.infinity,
                            height: 1,
                            margin: EdgeInsets.all(10),
                          ),
                          _email != null ? Text(_email) : Text('যোগ করা হয়নি'),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'নম্বর',
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            color: Common.darkGreyColor,
                            width: double.infinity,
                            height: 1,
                            margin: EdgeInsets.all(10),
                          ),
                          _number != null
                              ? Text(_number)
                              : Text('যোগ করা হয়নি'),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: _imageFromPreferences,
                      ),
                    ),
                    right: 0,
                    left: 0,
                    bottom: 290,
                  ),
                  Positioned(
                      top: 90,
                      right: 20,
                      child: IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => UpdateProfile()))
                                .whenComplete(() => initState());
                          })),
                ],
              ),
            ],
          )),
    ));
  }
}
