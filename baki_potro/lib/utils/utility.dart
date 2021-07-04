import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Image circularImageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  static Image circularEmptyImage() {
    return Image.asset(
      'images/profile.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
