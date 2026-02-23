import 'package:basic_landing_page/providers/coin_provider.dart';
import 'package:basic_landing_page/src/app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox('cryptoBox');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CoinProvider()),
  ], child: MyApp()));
}
