import 'package:basic_landing_page/src/app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox('cryptoBox');

  runApp(const MyApp());
}
