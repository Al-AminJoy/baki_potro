import 'package:baki_potro/models/category.dart';
import 'package:baki_potro/service/category_service.dart';
import 'package:flutter/material.dart';


class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var _category_controller = TextEditingController();
  CategoryService _categoryService = CategoryService();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
///insert category
  _addCategory() async {
    if (_category_controller.text != '') {
      var categoryList = [];
      Category category = Category();
      category.name = _category_controller.text;
      categoryList.add(category);
      var result = await _categoryService.saveCategory(category);
      print(result);
      if (result != null) {
        _category_controller.clear();
        _showSnackBar(new Text('সফল'));
      } else {
        _showSnackBar(new Text('ব্যর্থ'));
      }
    } else {
      _showSnackBar(new Text('অবৈধ বিভাগ'));
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
        title: new Text('বিভাগ যোগ করুন'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              child: TextField(
                  controller: _category_controller,
                  maxLength: 16,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2)),
                      filled: true,
                      //  fillColor: Colors.grey[300],
                      hintText: 'বিভাগ'))),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 50.0, right: 50.0, top: 10),
            child: ElevatedButton(
              onPressed: _addCategory,
              child: Text('যোগ করুন'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
