import 'package:flutter/material.dart';
import 'package:pakmart/app.dart';
import 'package:pakmart/src/di/injector.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
 await  configureDependencies();
  runApp(const MyApp());
}
