import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/app.dart';

void main() {
  print('Starting app...');
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    print('Initializing FFI...');
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print('FFI Initialized');
  }
  WidgetsFlutterBinding.ensureInitialized();
  print('WidgetsBinding initialized');
  runApp(const App());
  print('runApp called');
}
