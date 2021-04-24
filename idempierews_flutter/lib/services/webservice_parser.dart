import 'package:flutter/foundation.dart';
import 'package:idempierews_dart/idempierews_dart.dart';
import 'package:idempierews_flutter/models/soap_model.dart';
import 'package:idempierews_flutter/services/webservices.dart';

Future<bool> checkConnection() async {
  WebServiceRequestData _serviceRequestData = WebServiceRequestData();
  if (!_serviceRequestData.isDataComplete()) return false;
  AuthenticationWebService authenticationWebService =
      AuthenticationWebService(_serviceRequestData);
  dynamic response = await authenticationWebService.runWebService();

  if (response == null ||
      response.getStatus == WebServiceResponseStatus.Error) {
    return false;
  }
  return true;
}

Future<List<MBPartner>> fetchPartners() async {
  WebServiceRequestData _serviceRequestData = WebServiceRequestData();

  QueryBPartnersWebService authenticationWebService =
      QueryBPartnersWebService(_serviceRequestData);

  final response = await authenticationWebService.queryPerformed();
  return compute(parsePartners, response);
  // return parsePartners(response);
}

List<MBPartner> parsePartners(WindowTabDataResponse response) {
  List<MBPartner> partners = List.empty(growable: true);
  MBPartner partner;
  if (response.getStatus == WebServiceResponseStatus.Error) {
    print(response.getErrorMessage);
    throw Exception(response.getErrorMessage);
  } else {
    print('Total rows: ${response.getTotalRows}');
    print('Num rows: ${response.getNumRows}');
    print('Start row: ${response.getStartRow}');
    print('');
    for (int i = 0; i < response.getDataSet.getRowsCount(); i++) {
      print('Row: ${i + 1}');
      partner = MBPartner();
      for (int j = 0; j < response.getDataSet.getRow(i).getFieldsCount(); j++) {
        Field field = response.getDataSet.getRow(i).getFields.elementAt(j);
        print('Column: ${field.getColumn} = ${field.getValue}');
        if (field.getColumn == 'Value')
          partner.value = field.getStringValue();
        else if (field.getColumn == 'Name')
          partner.name = field.getStringValue();
        else if (field.getColumn == 'TaxiID')
          partner.taxId = field.getIntValue();
        else if (field.getColumn == 'C_BPartner_ID')
          partner.id = field.getIntValue();
      }
      partners.add(partner);
      print('');
    }
  }

  return partners;
}

Future<List<MInvoice>> fetchInvoices(int partnerId) async {
  WebServiceRequestData _serviceRequestData = WebServiceRequestData();
  QueryMInvoiceWebService invoiceWebService =
      QueryMInvoiceWebService.param(_serviceRequestData, partnerId);

  final response = await invoiceWebService.queryPerformed();

  return compute(parseInvoices, response);
}

List<MInvoice> parseInvoices(WindowTabDataResponse response) {
  List<MInvoice> invoices = List.empty(growable: true);
  MInvoice invoice;
  if (response.getStatus == WebServiceResponseStatus.Error) {
    throw Exception(response.getErrorMessage);
  } else {
    print('Total rows: ${response.getTotalRows}');
    print('Num rows: ${response.getNumRows}');
    print('Start row: ${response.getStartRow}');
    print('');
    for (int i = 0; i < response.getDataSet.getRowsCount(); i++) {
      print('Row: ${i + 1}');
      invoice = MInvoice();
      for (int j = 0; j < response.getDataSet.getRow(i).getFieldsCount(); j++) {
        Field field = response.getDataSet.getRow(i).getFields.elementAt(j);
        print('Column: ${field.getColumn} = ${field.getValue}');
        if (field.getColumn == 'C_Invoice_ID')
          invoice.id = field.getIntValue();
        else if (field.getColumn == 'DocumentNo')
          invoice.documentno = field.getStringValue();
        else if (field.getColumn == 'DateInvoiced')
          invoice.dateInvoiced = field.getDateValue();
        else if (field.getColumn == 'GrandTotal')
          invoice.grandTotal = field.getDoubleValue();
        else if (field.getColumn == 'IsPaid')
          invoice.isPaid = field.getboolValue();
        else if (field.getColumn == 'C_BPartner_ID')
          invoice.partnerId = field.getIntValue();
        else if (field.getColumn == 'C_Currency_ID')
          invoice.currencyId = field.getIntValue();
      }
      invoices.add(invoice);
      print('');
    }
  }
  return invoices;
}

Future<List<MPayment>> fetchPayments(int partnerId) async {
  WebServiceRequestData _serviceRequestData = WebServiceRequestData();
  QueryPaymentWebService invoiceWebService =
      QueryPaymentWebService.param(_serviceRequestData, partnerId);

  final response = await invoiceWebService.queryPerformed();

  return compute(parsePayments, response);
}

List<MPayment> parsePayments(WindowTabDataResponse response) {
  List<MPayment> payments = List.empty(growable: true);
  MPayment payment;
  if (response.getStatus == WebServiceResponseStatus.Error) {
    print(response.getErrorMessage);
    throw Exception(response.getErrorMessage);
  } else {
    print('Total rows: ${response.getTotalRows}');
    print('Num rows: ${response.getNumRows}');
    print('Start row: ${response.getStartRow}');
    print('');
    for (int i = 0; i < response.getDataSet.getRowsCount(); i++) {
      print('Row: ${i + 1}');
      payment = MPayment();
      for (int j = 0; j < response.getDataSet.getRow(i).getFieldsCount(); j++) {
        Field field = response.getDataSet.getRow(i).getFields.elementAt(j);
        print('Column: ${field.getColumn} = ${field.getValue}');
        if (field.getColumn == 'C_Payment_ID')
          payment.id = field.getIntValue();
        else if (field.getColumn == 'DocumentNo')
          payment.documentno = field.getStringValue();
        else if (field.getColumn == 'TenderType')
          payment.tenderType = field.getStringValue();
        else if (field.getColumn == 'DateTrx')
          payment.dateTrx = field.getDateValue();
        else if (field.getColumn == 'Created')
          payment.created = field.getDateValue();
        else if (field.getColumn == 'PayAmt')
          payment.payAmt = field.getDoubleValue();
        else if (field.getColumn == 'IsAllocated')
          payment.isAllocate = field.getboolValue();
        else if (field.getColumn == 'C_BPartner_ID')
          payment.partnerId = field.getIntValue();
        else if (field.getColumn == 'C_Invoice_ID')
          payment.invoiceId = field.getIntValue();
        else if (field.getColumn == 'C_BankAccount_ID')
          payment.accountID = field.getIntValue();
      }
      payments.add(payment);
      print('');
    }
  }
  return payments;
}

Future<String> createPayment(MPayment payment) async {
  WebServiceRequestData _serviceRequestData = WebServiceRequestData();
  CreatePaymentWebService createPaymentWebServiceWebService =
      CreatePaymentWebService.param(_serviceRequestData, payment);

  final response = await createPaymentWebServiceWebService.queryPerformed();

  return response;
}

Future<String> updatePayment(MPayment payment) async {
  WebServiceRequestData _serviceRequestData = WebServiceRequestData();
  UpdatePaymentWebService updatePaymentWebServiceWebService =
      UpdatePaymentWebService.param(_serviceRequestData, payment);

  final response = await updatePaymentWebServiceWebService.queryPerformed();

  return response;
}
