import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:idempierews_flutter/screens/bpartner_screen.dart';
import 'package:idempierews_flutter/themes/material_demo_theme_data.dart';
import 'package:idempierews_flutter/utilities/applocalizations.dart';
import 'package:preferences/preferences.dart';
import 'package:validators/validators.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'Preferences Demo',
      theme: MaterialDemoThemeData.themeData,
      home: PreferencePageScreen(),
    );
  }
}

class PreferencePageScreen extends StatefulWidget {
  @override
  _PreferencePageScreenState createState() => _PreferencePageScreenState();
}

class _PreferencePageScreenState extends State<PreferencePageScreen> {
  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: 'Change info base on your configuration');

    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('title_pref_string')),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: PreferencePage([
                  PreferenceTitle(AppLocalizations.of(context)
                      .translate('conf_pref_string')),
                  TextFieldPreference(
                    AppLocalizations.of(context)
                        .translate('server_pref_string'),
                    'pref_server',
                    defaultVal: 'https://test.idempiere.org',
                  ),
                  TextFieldPreference(
                      AppLocalizations.of(context)
                          .translate('email_pref_string'),
                      'pref_user',
                      defaultVal: 'superuser @ idempiere.com',
                      validator: (str) {
                    if (!isEmail(str)) {
                      return "Invalid email";
                    }
                    return null;
                  }),
                  TextFieldPreference(
                    AppLocalizations.of(context)
                        .translate('password_pref_string'),
                    'pref_pwd',
                    defaultVal: 'System',
                    obscureText: true,
                  ),
                  TextFieldPreference(
                      AppLocalizations.of(context)
                          .translate('client_pref_string'),
                      'pref_client', validator: (str) {
                    if (!isNumeric(str) && str.toString().isNotEmpty) {
                      return "Invalid Number";
                    }
                    return null;
                  }),
                  TextFieldPreference(
                      AppLocalizations.of(context).translate('org_pref_string'),
                      'pref_org', validator: (str) {
                    if (!isNumeric(str) && str.toString().isNotEmpty) {
                      return "Invalid Number";
                    }
                    return null;
                  }),
                  TextFieldPreference(
                      AppLocalizations.of(context)
                          .translate('role_pref_string'),
                      'pref_role', validator: (str) {
                    if (!isNumeric(str) && str.toString().isNotEmpty) {
                      return "Invalid Number";
                    }
                    return null;
                  }),
                  TextFieldPreference(
                      AppLocalizations.of(context)
                          .translate('warehouse_pref_string'),
                      'pref_warehouse', validator: (str) {
                    if (!isNumeric(str) && str.toString().isNotEmpty) {
                      return "Invalid Number";
                    }
                    return null;
                  }),
                  // PreferenceHider([
                  //   PreferenceTitle(AppLocalizations.of(context)
                  //       .translate('perso_pref_string')),
                  //   RadioPreference(
                  //     AppLocalizations.of(context)
                  //         .translate('light_theme_pref_string'),
                  //     'light',
                  //     'ui_theme',
                  //     isDefault: true,
                  //     onSelect: () {
                  //       PrefService.setBool('isDark', false);
                  //       DynamicTheme.of(context)
                  //           .setBrightness(Brightness.light);
                  //     },
                  //   ),
                  //   RadioPreference(
                  //     AppLocalizations.of(context)
                  //         .translate('dark_theme_pref_string'),
                  //     'dark',
                  //     'ui_theme',
                  //     onSelect: () {
                  //       PrefService.setBool('isDark', true);
                  //       DynamicTheme.of(context).setBrightness(Brightness.dark);
                  //     },
                  //   ),
                  // ], '!advanced_enabled'),
                  PreferenceTitle(AppLocalizations.of(context)
                      .translate('advanced_pref_string')),
                  CheckboxPreference(
                    AppLocalizations.of(context)
                        .translate('enable_adv_pref_string'),
                    'advanced_enabled',
                    onChange: () {
                      setState(() {});
                    },
                  )
                ]),
              ),
            ),
            RaisedButton(
              child: Text(
                  AppLocalizations.of(context).translate('login_pref_string')),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => WelcomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
