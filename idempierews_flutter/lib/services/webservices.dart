import 'package:idempierews_dart/idempierews_dart.dart';
import 'package:idempierews_flutter/models/soap_model.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preferences.dart';

/// @author [Mohamed Dernoun]
/// @email [mohamed.dernoun@itbridge.dz]

class WebServiceRequestData {
  String _username;
  String _password;
  String _clientId;
  String _roleId;
  String _orgId;
  String _attemptsNo;
  String _timeout;
  String _attemptsTimeout;
  String _urlBase;
  String _warehouseId;

  String get getUsername => _username;

  String get getPassword => _password;

  String get getClientId => _clientId;

  String get getRoleId => _roleId;

  String get getOrgId => _orgId;

  String get getAttemptsNo => _attemptsNo;

  String get getTimeout => _timeout;

  String get getAttemptsTimeout => _attemptsTimeout;

  String get getUrlBase => _urlBase;

  String get getWarehouseId => _warehouseId;

  WebServiceRequestData() {
    // if (context != null) {
    //Variables from preferences
    _readPreferenceVariables();

    //Variables in the properties file
    readValues();

    //username and password
    readCredentials();
    // }
  }
  void _readPreferenceVariables() {
    _urlBase = PrefService.getString('pref_server');
    _orgId = PrefService.getString('pref_org');
    _clientId = PrefService.getString('pref_client');
    _roleId = PrefService.getString('pref_role');
    _warehouseId = PrefService.getString('pref_warehouse');
  }

  void readCredentials() {
    _username = PrefService.getString('pref_user');
    _password = PrefService.getString('pref_pwd');
  }

  void readValues() {
    _attemptsNo = PrefService.getString('pref_attemptsNo');
    _timeout = PrefService.getString('pref_timeout');
    _attemptsTimeout = PrefService.getString('pref_attemptsTimeout');
  }

  bool isDataComplete() {
    if (_username != null &&
        _username.isNotEmpty &&
        _password != null &&
        _password.isNotEmpty &&
        _clientId != null &&
        _clientId.isNotEmpty &&
        _roleId != null &&
        _roleId.isNotEmpty &&
        _orgId != null &&
        _orgId.isNotEmpty &&
        _attemptsNo != null &&
        _attemptsNo.isNotEmpty &&
        _attemptsNo != null &&
        _attemptsNo.isNotEmpty &&
        _timeout != null &&
        _timeout.isNotEmpty &&
        _attemptsTimeout != null &&
        _attemptsTimeout.isNotEmpty &&
        _urlBase != null &&
        _urlBase.isNotEmpty) return true;

    return false;
  }
}

abstract class AbstractWSObject {
  LoginRequest _login;
  WebServiceConnection _client;
  WebServiceRequestData _wsData;
  dynamic _parameter;

  AbstractWSObject(WebServiceRequestData wsData) {
    this._wsData = wsData;

    // if (wsData.isDataComplete()) {
    _initLogin();
    _initClient();
    // runWebService();
    // }
  }

  AbstractWSObject.param(WebServiceRequestData wsData, dynamic parameter) {
    this._wsData = wsData;
    this._parameter = parameter;

    // if (wsData.isDataComplete()) {
    _initLogin();
    _initClient();
    // }
  }

  // final scaffoldKey = new GlobalKey<ScaffoldState>();

  // void showSnackBar(String text) {
  //   scaffoldKey.currentState
  //       .showSnackBar(new SnackBar(content: new Text(text)));
  // }

  void _initLogin() {
    _login = new LoginRequest();

    _login.setUser = _wsData.getUsername;
    _login.setPass = _wsData.getPassword;
    _login.setClientID = int.parse(_wsData.getClientId);
    _login.setRoleID = int.parse(_wsData.getRoleId);
    _login.setOrgID = int.parse(_wsData.getOrgId);
    _login.setWarehouseID = int.parse(_wsData.getWarehouseId);
  }

  void _initClient() {
    _client = new WebServiceConnection();

    _client.setAttempts = int.parse(_wsData.getAttemptsNo);
    _client.setTimeout = int.parse(_wsData.getTimeout);
    _client.setAttemptsTimeout = int.parse(_wsData.getAttemptsTimeout);
    _client.setUrl = _wsData.getUrlBase;
    _client.setAppName = 'iTBridge APP';
  }

  LoginRequest get getLogin => _login;

  WebServiceConnection get getClient => _client;

  Future<dynamic> runWebService() async {
    return await queryPerformed();
  }

  String getServiceType();
  Future<dynamic> queryPerformed();

  dynamic get getParameter => _parameter;
}

class AuthenticationWebService extends AbstractWSObject {
  static const String SERVICE_TYPE = 'SyncOrder';

  AuthenticationWebService(WebServiceRequestData wsData) : super(wsData);

  @override
  String getServiceType() => SERVICE_TYPE;

  @override
  Future<CompositeResponse> queryPerformed() async {
    CompositeOperationRequest compositeOperation =
        new CompositeOperationRequest();
    compositeOperation.setLogin = getLogin;
    compositeOperation.setWebServiceType = getServiceType();

    WebServiceConnection client = getClient;

    try {
      CompositeResponse response = await client.sendRequest(compositeOperation);
      return response;
    } catch (e) {
      print(e);
      // _success = false;
    }
    return null;
  }
}

class QueryBPartnersWebService extends AbstractWSObject {
  static const String SERVICE_TYPE = 'QueryBPartner';

  QueryBPartnersWebService(WebServiceRequestData wsData) : super(wsData);

  @override
  String getServiceType() => SERVICE_TYPE;

  @override
  Future<WindowTabDataResponse> queryPerformed() async {
    QueryDataRequest ws = QueryDataRequest();
    ws.setWebServiceType = getServiceType();
    ws.setLogin = getLogin;

    WebServiceConnection client = getClient;

    try {
      WindowTabDataResponse response = await client.sendRequest(ws);
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class QueryMInvoiceWebService extends AbstractWSObject {
  static const String SERVICE_TYPE = 'QueryInvoice';

  QueryMInvoiceWebService.param(WebServiceRequestData wsData, dynamic parameter)
      : super.param(wsData, parameter);

  @override
  String getServiceType() => SERVICE_TYPE;

  @override
  Future<WindowTabDataResponse> queryPerformed() async {
    int partnerId = getParameter;
    QueryDataRequest ws = QueryDataRequest();
    ws.setWebServiceType = getServiceType();
    ws.setLogin = getLogin;

    DataRow dataRow = DataRow();
    dataRow.addField('C_BPartner_ID', partnerId);
    ws.setDataRow = dataRow;

    WebServiceConnection client = getClient;

    try {
      WindowTabDataResponse response = await client.sendRequest(ws);
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class QueryPaymentWebService extends AbstractWSObject {
  static const String SERVICE_TYPE = 'QueryPayment';

  QueryPaymentWebService.param(WebServiceRequestData wsData, dynamic parameter)
      : super.param(wsData, parameter);

  @override
  String getServiceType() => SERVICE_TYPE;

  @override
  Future<WindowTabDataResponse> queryPerformed() async {
    int partnerId = getParameter;
    QueryDataRequest ws = QueryDataRequest();
    ws.setWebServiceType = getServiceType();
    ws.setLogin = getLogin;

    DataRow dataRow = DataRow();
    dataRow.addField('C_BPartner_ID', partnerId);
    ws.setDataRow = dataRow;

    WebServiceConnection client = getClient;

    try {
      WindowTabDataResponse response = await client.sendRequest(ws);
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class CreatePaymentWebService extends AbstractWSObject {
  CreatePaymentWebService.param(WebServiceRequestData wsData, dynamic payment)
      : super.param(wsData, payment);

  @override
  String getServiceType() => 'CreatePayment';

  @override
  Future<String> queryPerformed() async {
    MPayment payment = getParameter;
    CreateDataRequest createData = new CreateDataRequest();
    createData.setLogin = getLogin;
    createData.setWebServiceType = getServiceType();
    String responseStatus = '';

    DataRow data = new DataRow();
    data.addField('C_Invoice_ID', payment.invoiceId);
    data.addField('C_BPartner_ID', payment.partnerId);
    data.addField('PayAmt', payment.payAmt);
    data.addField('C_DocType_ID', '119');
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    data.addField('DateTrx', formatter.format(now));
    data.addField('C_BankAccount_ID', '200000');
    data.addField('IsReceipt', 'Y');
    data.addField('C_Currency_ID', payment.currencyId);
    if (payment.documentno != '') {
      data.addField('DocumentNo', payment.documentno);
      data.addField('TenderType', 'K');
    } else
      data.addField('TenderType', 'X');

    createData.setDataRow = data;

    WebServiceConnection client = getClient;
    try {
      StandardResponse response = await client.sendRequest(createData);

      if (response.getStatus == WebServiceResponseStatus.Error) {
        responseStatus = response.getErrorMessage;
        print(response.getErrorMessage);
      } else {
        print('RecordID: ${response.getRecordID}');
        print('');

        for (int i = 0; i < response.getOutputFields.getFieldsCount(); i++) {
          print(
              'Column ${i + 1}: ${response.getOutputFields.getFieldAt(i).getColumn} = ${response.getOutputFields.getFieldAt(i).getValue}');
        }
        print('');
      }
      return responseStatus;
    } catch (e) {
      print(e);
    }
    return responseStatus;
  }
}

class UpdatePaymentWebService extends AbstractWSObject {
  UpdatePaymentWebService.param(WebServiceRequestData wsData, dynamic payment)
      : super.param(wsData, payment);
  @override
  String getServiceType() => 'UpdatePayment';

  @override
  Future<String> queryPerformed() async {
    UpdateDataRequest updateData = new UpdateDataRequest();
    updateData.setLogin = getLogin;
    updateData.setWebServiceType = getServiceType();
    MPayment payment = getParameter;
    updateData.setRecordID = payment.id;
    String responseStatus = '';

    DataRow data = new DataRow();
    data.addField('PayAmt', payment.payAmt);
    data.addField('DocumentNo', payment.documentno);
    updateData.setDataRow = data;

    WebServiceConnection client = getClient;
    try {
      StandardResponse response = await client.sendRequest(updateData);

      if (response.getStatus == WebServiceResponseStatus.Error) {
        print(response.getErrorMessage);
        responseStatus = response.getErrorMessage;
        return responseStatus;
      } else {
        print('RecordID: ${response.getRecordID}');
        print('');

        for (int i = 0; i < response.getOutputFields.getFieldsCount(); i++) {
          print(
              'Column ${i + 1}: ${response.getOutputFields.getFieldAt(i).getColumn} = ${response.getOutputFields.getFieldAt(i).getValue}');
        }
        print('');
      }
    } catch (e) {
      print(e);
    }
    return responseStatus;
  }
}
