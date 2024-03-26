
import 'dart:developer';

class Print{
  String date;
  String hour;
  final String fileName;
  final String printer;
  final String cost;
  final String account;
  final Map<String,int> details;

  Print.sec(this.date, this.hour, this.account, this.fileName, this.printer, this.cost, this.details);
  Print(date, this.account, this.fileName, this.printer, this.cost, this.details){
    List<String> s = date.split(' ');

    this.date = s[0].replaceAll('\n', '');
    this.hour = s[1].replaceAll('\n', '');
    log(this.date);
    log(this.hour);
  }

  @override
  String toString() {
    return '''$fileName - $date - $hour - $printer - $cost - $details -  $account ''';
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'date': date,
      'hour' : hour,
      'printer': printer,
      'cost': cost,
      'account': account,
      'details': details.toString()
    };
  }

  String getDetails(){
    String s = '';
    this.details.forEach((key, value) { s += key + ': ' + value.toString() + '\n';});
    return s;
  }

  String getNumPages(){
    int r = 0;
    List <int> l = details.values.toList();
    for (int a = 0; a<l.length; a+=2){
      r += l[a];
    }
    return r.toString();
  }

  void printDebug(){
    log('File Name: ' + this.fileName);
    log('Date: ' + this.date);
    log('Printer: ' + this.printer);
    log('Cost: ' + this.cost);
    log('Account: ' + this.account);
    log('Details' + this.details.toString());
  }

}