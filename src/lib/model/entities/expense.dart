
import 'dart:developer';

import '../utils/document_types_enum.dart';

/// Stores information about the user's profile.


var _orderExpenseTypes = ["Data limite de pagamento", "Juros de mora", "Valor a pagar"];

class Expense {
  final String description;
  final String course;
  bool paid;
  final String type;
  final String date;
  final String limitDate;
  String amount;
  final String status;
  DocumentT docType;
  String reference;
  String document;
  String interest;

  Expense.sec(this.description, this.course, this.type, this.date, this.limitDate,
      this.amount, this.status, String paid, String document, this.interest, this.docType){
    if(paid == 'true'){
      this.paid = true;
    }
    else {
      this.paid = false;
    }
    this.document = document;
    this.interest = this.interest == '' ? '0.00' : this.interest.substring(0, this.interest.length - 2).replaceAll(",", ".");
    this.amount = this.amount == '' ? '0.00' : this.amount.substring(0, this.amount.length - 2).replaceAll(",", ".");
  }

  Expense(this.description, this.course, this.type, this.date, this.limitDate, this.amount, this.status, this.interest){
    paid = false;
    document = 'none';
    docType = DocumentT.none;
    this.interest = this.interest == '' ? '0.00' : this.interest.substring(0, this.interest.length - 2).replaceAll(",", ".");
    this.amount = this.amount == '' ? '0.00' : this.amount.substring(0, this.amount.length - 2).replaceAll(",", ".");
  }

  void setDocType(DocumentT type){
    docType = type;
  }

  void setPaid(paid) {
    this.paid = paid;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Expense
        && other.description == description
        && other.course == course
        && other.type == type
        && other.amount == amount
        && other.limitDate == limitDate;
  }

  void setDocument(document) {
    this.document = document;
  }

  String toString() {
    return '''$description - $course - $paid - $type -  $date - $limitDate - $amount - $status - $document - $interest - $docType ''';

  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'course': course,
      'paid': paid.toString(),
      'type': type,
      'date': date,
      'limitDate': limitDate,
      'amount': amount,
      'status': status,
      'document': document,
      'interest': interest,
      'docType': docType.toString()
    };
  }


  static List<String> getOrderedExpenseTypes(){
    return _orderExpenseTypes;
  }

  void printDebug(){
    log('Description: ' + this.description);
    log('Course: ' +this.course);
    log('Paid?: ' +(this.paid).toString());
    log('Type: ' + this.type);
    log('Date: ' + this.date);
    log('Limit Date: ' + this.limitDate);
    log('Amount: ' + this.amount);
    log('Status: ' + this.status);
    log('Document: ' + this.document);
    log('Interest: ' + this.interest);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(limitDate, amount, description, course, type);

}


