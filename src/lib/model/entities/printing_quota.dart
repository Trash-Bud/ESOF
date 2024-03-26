
import 'dart:developer';

class PrintingQuota{
  String date;
  String hour;
  final String description;
  final String credit;
  final String iva;
  final String account;

  PrintingQuota.sec(this.date, this.hour, this.description, this.credit, this.iva, this.account);
  PrintingQuota(date, this.description, this.credit, this.iva, this.account){
    List<String> s = date.split(' ');

    this.date = s[0].replaceAll('\n', '');
    this.hour = s[1].replaceAll('\n', '');
    log(this.date);
    log(this.hour);
  }

  @override
  String toString() {
    return '''$description - $date - $hour - $credit - $iva -  $account ''';
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'date': date,
      'hour': hour,
      'credit': credit,
      'iva': iva,
      'account': account,
    };
  }

  void printDebug(){
    log('Description: ' + this.description);
    log('Date: ' + this.date);
    log('Limit Date: ' + this.credit);
    log('Amount: ' + this.iva);
    log('Status: ' + this.account);
  }

}