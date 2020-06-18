import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idempierews_flutter/models/soap_model.dart';
import 'package:idempierews_flutter/services/webservice_parser.dart';
import 'package:idempierews_flutter/utilities/applocalizations.dart';

class InvoicePayment extends StatefulWidget {
  @override
  _InvoicePaymentState createState() => _InvoicePaymentState();
}

class _InvoicePaymentState extends State<InvoicePayment>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List _kTabPages = <Widget>[
    InvoicePage(),
    PaymentPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabPages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List _kTabs = <Tab>[
      Tab(
        icon: Icon(
          Icons.receipt,
        ),
        text: AppLocalizations.of(context).translate('invoices_string'),
      ),
      Tab(
        icon: Icon(
          Icons.payment,
        ),
        text: AppLocalizations.of(context).translate('payments_string'),
      ),
    ];
    return Scaffold(
      appBar: null,
      body: TabBarView(
        children: _kTabPages,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.redAccent,
        child: TabBar(
          tabs: _kTabs,
          controller: _tabController,
        ),
      ),
    );
  }
}

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    final MBPartner partner = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(partner.name),
        ),
        body: Container(
          child: FutureBuilder<List<MInvoice>>(
            future: fetchInvoices(partner.id),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? RefreshIndicator(
                      child: InvoiceList(
                        invoices: snapshot.data,
                      ),
                      onRefresh: _refreshhandle,
                    )
                  : (snapshot.hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.bug_report),
                              Text(snapshot.error.toString())
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                              // backgroundColor: Colors.green,
                              // semanticsValue: 'Loading',
                              // valueColor:
                              //     AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                        ));
            },
          ),
        ),
      ),
    );
  }

  Future<Null> _refreshhandle() async {
    setState(() {});
  }
}

class InvoiceList extends StatelessWidget {
  final List<MInvoice> invoices;
  InvoiceList({Key key, this.invoices}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: (invoices[index].isPaid == false
                ? Colors.red[200]
                : Colors.greenAccent),
            child: ListTile(
              enabled: (invoices[index].isPaid == false ? true : false),
              onTap: () => _buildShowModalBottomSheet(context, invoices[index]),
              title: Text(
                invoices[index].documentno,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              subtitle: Text(
                invoices[index].dateInvoiced.toString(),
              ),
              leading: Icon(
                invoices[index].isPaid == false ? Icons.clear : Icons.check,
                color: Colors.blue,
                size: 32.0,
              ),
              trailing: Text(
                invoices[index].grandTotal.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  _buildShowModalBottomSheet(BuildContext context, MInvoice invoice) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              color: Color(0xFF737373),
              height: MediaQuery.of(context).size.height / 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_balance),
                      title: Text(
                        AppLocalizations.of(context).translate('check_string'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        _showCheckDialog(context, invoice);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text(
                        AppLocalizations.of(context).translate('cash_string'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        _showCashDialog(context, invoice);
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  Future<String> _showCheckDialog(BuildContext context, MInvoice invoice) {
    TextEditingController checkControler = TextEditingController();
    TextEditingController amountControler = TextEditingController();
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            '${AppLocalizations.of(context).translate('check_desc_string')} ${invoice.documentno}'),
        content: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('check_n_string'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                controller: checkControler,
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('amount_string'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                controller: amountControler,
              )
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
              elevation: 5.0,
              child: Text(
                AppLocalizations.of(context).translate('submit_string'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              onPressed: () async {
                // Navigator.of(context).pop(checkControler.text.toString());
                if (checkControler.text.toString().trim() == '') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: 'Error',
                    desc: 'Check N° is mandatory',
                    btnOkOnPress: () {},
                    btnOkColor: Colors.red,
                  )..show();
                }
                MPayment mPayment = MPayment.paymentFromInvoice(invoice);
                if (amountControler.text != '' &&
                    invoice.grandTotal >= double.parse(amountControler.text))
                  mPayment.payAmt = double.parse(amountControler.text);

                mPayment.documentno = checkControler.text.toString();

                String response = await createPayment(mPayment);
                if (response == '') {
                  AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      title: AppLocalizations.of(context)
                          .translate('succes_string'),
                      desc: AppLocalizations.of(context)
                          .translate('pay_cr_succes_string'),
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                      },
                      btnOkIcon: Icons.check_circle,
                      onDissmissCallback: () {
                        debugPrint('Dialog Dissmiss from callback');
                      }).show();
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: 'Error',
                    desc: response,
                    btnOkOnPress: () {},
                    btnOkColor: Colors.red,
                  )..show();
                }
              })
        ],
      ),
    );
  }

  Future<String> _showCashDialog(BuildContext context, MInvoice invoice) {
    TextEditingController amountControler = TextEditingController();
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('cash_string')),
        content: TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('amount_string'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          controller: amountControler,
        ),
        actions: <Widget>[
          RaisedButton(
              elevation: 5.0,
              child: Text(
                AppLocalizations.of(context).translate('submit_string'),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              onPressed: () async {
                MPayment mPayment = MPayment.paymentFromInvoice(invoice);
                if (amountControler != null &&
                    invoice.grandTotal >= double.parse(amountControler.text))
                  mPayment.payAmt = double.parse(amountControler.text);
                String response = await createPayment(mPayment);
                if (response == '') {
                  AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      title: AppLocalizations.of(context)
                          .translate('succes_string'),
                      desc: AppLocalizations.of(context)
                          .translate('pay_cr_succes_string'),
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                      },
                      btnOkIcon: Icons.check_circle,
                      onDissmissCallback: () {
                        debugPrint('Dialog Dissmiss from callback');
                      }).show();
                } else {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: false,
                      title: 'Error',
                      desc: response,
                      btnOkOnPress: () {},
                      btnOkColor: Colors.red)
                    ..show();
                }
              })
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final MBPartner partner = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(partner.name),
        ),
        body: Container(
          child: FutureBuilder<List<MPayment>>(
            future: fetchPayments(partner.id),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? RefreshIndicator(
                      child: PaymentList(payments: snapshot.data),
                      onRefresh: _refreshHandle,
                    )
                  : (snapshot.hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.error),
                              Text(snapshot.error.toString())
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.add,
            ),
            onPressed: () async {
              await _showCheckDialog(context, partner.id);
              _refreshHandle();
            }),
      ),
    );
  }

  Future<void> _refreshHandle() async {
    setState(() {});
  }

  Future<String> _showCheckDialog(BuildContext context, int partnerId) {
    return showDialog(
        context: context, builder: (_) => PaymentDialog(partnerId: partnerId));
  }
}

class PaymentDialog extends StatefulWidget {
  final int partnerId;
  PaymentDialog({Key key, this.partnerId});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  TextEditingController checkControler = TextEditingController();
  TextEditingController amountControler = TextEditingController();
  static const menuItems = <String>['DZD', 'EUR', 'USD', 'TND', 'SAR'];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
      .toList();
  String _curSelected;
  String _response = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('create_pay_string')),
      content: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Text(
                  AppLocalizations.of(context).translate('currency_string')),
              trailing: DropdownButton(
                hint: Text(
                    AppLocalizations.of(context).translate('choose_string')),
                items: _dropDownMenuItems,
                value: _curSelected,
                onChanged: (String value) {
                  setState(() {
                    _curSelected = value;
                  });
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate('check_n_string'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              controller: checkControler,
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate('amount_string'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              controller: amountControler,
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
            elevation: 5.0,
            child: Text(
              AppLocalizations.of(context).translate('submit_string'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
            onPressed: () async {
              // Navigator.of(context).pop(checkControler.text.toString());
              MPayment mPayment = MPayment();
              mPayment.partnerId = widget.partnerId;
              switch (_curSelected) {
                case 'USD':
                  mPayment.currencyId = 100;
                  break;
                case 'EUR':
                  mPayment.currencyId = 102;
                  break;
                case 'DZD':
                  mPayment.currencyId = 235;
                  break;
                case 'SAR':
                  mPayment.currencyId = 317;
                  break;
                case 'TND':
                  mPayment.currencyId = 321;
                  break;
                default:
              }
              mPayment.documentno = checkControler.text;

              if (amountControler.text != '')
                mPayment.payAmt = double.parse(amountControler.text);

              if (mPayment.currencyId != null && mPayment.payAmt != null) {
                _response = await createPayment(mPayment);
                if (_response == '') {
                  AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      title: AppLocalizations.of(context)
                          .translate('succes_string'),
                      desc: AppLocalizations.of(context)
                          .translate('pay_cr_succes_string'),
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                        Navigator.pop(context);
                      },
                      btnOkIcon: Icons.check_circle,
                      onDissmissCallback: () {
                        debugPrint('Dialog Dissmiss from callback');
                      }).show();
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: 'Error',
                    desc: _response,
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                    btnOkColor: Colors.red,
                  )..show();
                }
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: false,
                  title: 'Error',
                  desc: 'Fill the currency and the amount',
                  btnOkOnPress: () {},
                  btnOkColor: Colors.red,
                )..show();
              }
            })
      ],
    );
  }
}

class PaymentList extends StatefulWidget {
  final List<MPayment> payments;

  PaymentList({Key key, this.payments}) : super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.payments.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: (widget.payments[index].isAllocate == false
                ? Colors.red[200]
                : Colors.greenAccent),
            child: ListTile(
              // enabled: (payments[index].isAllocate == false ? true : false),
              onTap: () => showBottomSheet(
                  // isScrollControlled: true,
                  context: context,
                  builder: (ctx) {
                    return _buildBottomSheet(ctx, widget.payments[index]);
                  }),
              title: Text(
                widget.payments[index].documentno,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              subtitle: Text(
                widget.payments[index].created.toString(),
              ),
              leading: Icon(
                widget.payments[index].currencyId == 100
                    ? Icons.attach_money
                    : Icons.euro_symbol,
                size: 32.0,
                color: Colors.blue,
              ),
              trailing: Text(
                widget.payments[index].payAmt.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  Container _buildBottomSheet(BuildContext context, MPayment payment) {
    TextEditingController checkControler = TextEditingController();
    TextEditingController amountControler = TextEditingController();
    return Container(
      height: 300,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text(
            '${AppLocalizations.of(context).translate('update_pay_string')}  ${payment.documentno}',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          TextField(
            controller: checkControler,
            enabled: payment.tenderType == 'K',
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.account_balance),
              labelText:
                  AppLocalizations.of(context).translate('u_check_n_string'),
            ),
            // inputFormatters: [
            //   BlacklistingTextInputFormatter(new RegExp('[ ]'))
            // ],
          ),
          TextField(
            // autofocus: true,
            controller: amountControler,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.attach_money),
              labelText:
                  AppLocalizations.of(context).translate('u_amount_string'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton.icon(
              icon: Icon(Icons.update),
              label: Text(AppLocalizations.of(context)
                  .translate('update_close_pay_string')),
              onPressed: () async {
                if (amountControler.text != '')
                  payment.payAmt = double.parse(amountControler.text);
                if (checkControler.text != '')
                  payment.documentno = checkControler.text;
                String response = await updatePayment(payment);
                if (response == '') {
                  AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      title: AppLocalizations.of(context)
                          .translate('succes_string'),
                      desc: AppLocalizations.of(context)
                          .translate('pay_up_succes_string'),
                      btnOkOnPress: () {
                        debugPrint('OnClcik');
                      },
                      btnOkIcon: Icons.check_circle,
                      onDissmissCallback: () {
                        debugPrint('Dialog Dissmiss from callback');
                      })
                    ..show();
                  // setState(() {
                  //   print('state was called');
                  // });
                } else {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: false,
                      title: 'Error',
                      desc: response,
                      btnOkOnPress: () {},
                      btnOkColor: Colors.red)
                    ..show();
                }
                setState(() {});
                // Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
