
import 'package:uni/model/entities/print.dart';
import 'package:uni/model/entities/printing_quota.dart';

class Prints{
  final List<PrintingQuota> printingQuotas;
  final List<Print> prints;

  Prints(this.printingQuotas,this.prints);
}