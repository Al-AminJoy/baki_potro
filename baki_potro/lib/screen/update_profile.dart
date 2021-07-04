import 'dart:typed_data';

import 'package:baki_potro/utils/shared_preference.dart';
import 'package:baki_potro/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:progress_dialog/progress_dialog.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  Future<File> imageFile;
  Uint8List _imageFromPreferences = null;
  String _name;
  String _email;
  String _number;
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  String _image;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _showSnackBar(message) {
    var snackBar = new SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }
///show image preview
  _show_preview() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.memory(
                _imageFromPreferences,
                width: 100,
                height: 250,
                fit: BoxFit.cover,
              ),
            ));
      },
    );
  }

  @override
  void initState() {
    setState(() {
      _loadDataFromPreferences();
    });
  }
///image picker from gallery
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }
///load shared preferences data
  _loadDataFromPreferences() {
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
        _nameController.text = _name;
      });
    });
    SharedPref.getFromPreferences(SharedPref.EMAIL_KEY).then((email) {
      if (email == null) {
        return;
      }
      setState(() {
        _email = email;
        _emailController.text = _email;
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
///load image from gallery and shared preferences
  Widget imageFromGallery() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          _image = Utility.base64String(snapshot.data.readAsBytesSync());
          return Center(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.file(
              snapshot.data,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ));
        } else if (null != snapshot.error) {
          //_showSnackBar(new Text('I am called2'));

          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          //showSnackBar(new Text('I am called3'));

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
                    child: Utility.circularEmptyImage()));
          }
        }
      },
    );
  }
///update profile data
  _updateData() {
    var email = _emailController.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email != '' && emailValid == false) {
      _showSnackBar(new Text('অবৈধ ইমেল'));
    } else if (email == '' || emailValid == true) {
      SharedPref.saveToPreferences(SharedPref.IMAGE_KEY, _image);
      SharedPref.saveToPreferences(SharedPref.NAME_KEY, _nameController.text);
      SharedPref.saveToPreferences(SharedPref.EMAIL_KEY, _emailController.text);
      _showSnackBar(new Text('হালনাগাদ হয়েছে'));
    }
  }
///show toast
  show_toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
///show dialog for update,preview and remove image
  _show_dialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          pickImageFromGallery(ImageSource.gallery);
                          imageFromGallery();
                          Navigator.pop(context);
                        });
                      },
                      child: new Text('Upload Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_imageFromPreferences != null) {
                          _show_preview();
                          Navigator.pop(context);
                        } else {
                          show_toast('Update Image First');
                        }
                      },
                      child: new Text('Preview Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageFile = null;
                          _imageFromPreferences = null;
                          imageFromGallery();
                          Navigator.pop(context);
                        });
                      },
                      child: new Text('Remove Image'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: new AppBar(
        title: new Text('প্রোফাইল হালনাগাদ'),
      ),
      body: new SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        imageFromGallery(),
                        SizedBox(height: 15.0),
                        Container(
                          child: new TextField(
                            controller: _nameController,
                            maxLength: 32,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Colors.yellow, width: 2)),
                                filled: true,
                                //  fillColor: Colors.grey[300],
                                hintText: 'নাম'),
                          ),
                        ),
                        Container(
                          child: new TextField(
                              controller: _emailController,
                              maxLength: 32,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Colors.yellow, width: 2)),
                                  filled: true,
                                  //  fillColor: Colors.grey[300],
                                  hintText: 'ইমেইল')),
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              _updateData();
                              //   await pr.show();
                            },
                            child: new Text('ঠিক আছে'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 70,
                        right: 98,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt,color: Colors.white,),
                          onPressed: () {
                            _show_dialog();
                          },
                        )),
                  ],
                ),
              ]),
            ),
          )),
    );
  }
}
