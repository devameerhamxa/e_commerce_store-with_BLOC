import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_store_with_bloc/core/di/service_locator.dart';
import 'package:e_commerce_store_with_bloc/core/app/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  };
  runApp(const MyApp());
}
