import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_hub/app/main_app.dart';
import 'package:note_hub/bloc/bloc_observer.dart';
import 'package:note_hub/utils/cache_helper.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init global bloc observer
  Bloc.observer = SimpleBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPreferencesHandler.init();
  runApp(MainApp());
}
