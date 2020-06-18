import 'package:flutter/material.dart';
import 'package:idempierews_flutter/screens/bpartner_screen.dart';
import 'package:idempierews_flutter/services/preference.dart';
import 'package:idempierews_flutter/services/webservice_parser.dart';
import 'package:preferences/preferences.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefService.init(prefix: '');

  PrefService.setDefaultValues({
    'pref_attemptsNo': '3',
    'pref_timeout': '5000',
    'pref_attemptsTimeout': '5000'
  });

  // print(await checkConnection());

  runApp(await checkConnection() ? WelcomePageMain() : MyApp());
}
