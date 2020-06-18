class MBPartner {
  int id;
  String value;
  String name;
  int taxId;
  double openBalance;

  MBPartner({this.id, this.value, this.name, this.taxId, this.openBalance});
}

class MInvoice {
  int id;
  String documentno;
  DateTime dateInvoiced;
  double grandTotal;
  bool isPaid;
  int currencyId;
  int partnerId;

  MInvoice(
      {this.id,
      this.documentno,
      this.dateInvoiced,
      this.grandTotal,
      this.isPaid,
      this.currencyId,
      this.partnerId});
}

class MPayment {
  static MPayment paymentFromInvoice(MInvoice invoice) {
    MPayment payment = MPayment();
    payment.currencyId = invoice.currencyId;
    payment.partnerId = invoice.partnerId;
    payment.payAmt = invoice.grandTotal;
    return payment;
  }

  int id;
  String documentno;
  String tenderType;
  DateTime dateTrx;
  DateTime created;
  double payAmt;
  bool isAllocate;
  int currencyId;
  int partnerId;
  int invoiceId;
  int accountID;

  MPayment(
      {this.id,
      this.documentno,
      this.dateTrx,
      this.created,
      this.payAmt,
      this.isAllocate,
      this.currencyId,
      this.partnerId,
      this.invoiceId,
      this.tenderType,
      this.accountID});
}
