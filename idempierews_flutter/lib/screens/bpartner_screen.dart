import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:idempierews_flutter/models/soap_model.dart';
import 'package:idempierews_flutter/screens/invoice_payment_screen.dart';
import 'package:idempierews_flutter/services/webservice_parser.dart';
import 'package:idempierews_flutter/utilities/applocalizations.dart';

class WelcomePageMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) =>
            ThemeData(brightness: brightness, accentColor: Colors.green),
        themedWidgetBuilder: (context, theme) {
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
              home: WelcomePage());
        });
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('title_string'),
          ),
        ),
        body: Container(
          child: FutureBuilder<List<MBPartner>>(
            future: fetchPartners(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? BPartnerList(partners: snapshot.data)
                  : (snapshot.hasError
                      ? Center(
                          child: Container(
                            child: Text(snapshot.error.toString()),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ));
            },
          ),
        ),
      ),
    );
  }
}

class BPartnerList extends StatelessWidget {
  final List<MBPartner> partners;

  BPartnerList({Key key, this.partners}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: partners.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => InvoicePayment(),
                    settings: RouteSettings(
                      arguments: partners[index],
                    ),
                  ),
                );
              },
              // trailing: Text(
              //   partners[index].openBalance.toString(),
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: partners[index].openBalance >= 0
              //           ? Colors.red
              //           : Colors.green),
              // ),
              title: Text(
                partners[index].name,
                style: TextStyle(fontSize: 22.0),
              ),
              subtitle: Text(
                partners[index].value,
              ),
              leading: Icon(
                Icons.face,
                color: Colors.blue,
              ),
            ),
          );
        });
  }
}
