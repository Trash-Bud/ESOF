import 'dart:developer';

/// Stores information about the user's profile.
class BankReference {
  final List<String> description;
  final List<String> amounts;
  final String entity;
  final String date;
  final String reference;
  final String totalAmount;


  BankReference(this.description, this.amounts, this.date, this.entity, this.reference, this.totalAmount){
  }

  String toString() {
    return '''$description - $amounts - $date - $entity - $reference -  $totalAmount ''';
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description.toString(),
      'amounts': amounts.toString(),
      'date': date,
      'entity': entity,
      'reference': reference,
      'totalAmount': totalAmount
    };
  }


  void printDebug(){
    log('Description: ' + this.description.toString());
    log('Amounts: ' + this.amounts.toString());
    log('Entity: ' + this.entity);
    log('Reference: ' + this.reference);
    log('Date: ' + this.date);
    log('Total Amount: ' + this.totalAmount);
  }

}
