import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:uni/model/entities/printing_quota.dart';

import 'dart:async';

import '../../model/entities/print.dart';

/// Parses information about the user's exams.
class ParserPrints {

   static const List<String> typesOfPaper = [
    'A4 Simplex',
    'A4 S. Cor',
    'A4 Duplex',
    'A4 D. Cor',
    'A3 Simplex',
    'A3 S. Cor',
    'A3 Duplex',
    'A3 D. Cor'
  ];

  Future<List<PrintingQuota>> parsePrintingQuotas(http.Response response, List<PrintingQuota> pqList, String account) async {
    final document = parse(response.body);
    final table = document.getElementById('tab_resultado');
    if (table == null) return pqList;
    final tableBody = table.getElementsByTagName('tbody');
    if (tableBody.isEmpty) return pqList;

    PrintingQuota pq;
    tableBody[0].querySelectorAll('tr').forEach((element) {
      List<String> list = [];
      element.querySelectorAll('td').forEach((element1) {
        list.add(element1.text);
      });

      pq = PrintingQuota(list[0],list[1],list[2],list[3],account);
      pqList.add(pq);
    });

    return pqList;
  }

  Future<List<Print>> parsePrints(http.Response response, List<Print> pList, String account) async {
    final document = parse(response.body);
    final table = document.getElementById('tab_resultado');
    if (table == null) return pList;
    final tableBody = table.getElementsByTagName('tbody');
    if (tableBody.isEmpty) return pList;
    Print p;
    tableBody[0].querySelectorAll('tr').forEach((element) {
      final List<String> list = [];
      element.querySelectorAll('td').forEach((element1) {
        list.add(element1.text);
      });

      final Map<String,int> details = {};
      for (int i = 5; i < 13; i++){
        if (list[i] != null && list[i] != ''){
          details[typesOfPaper[i-5]] = int.parse(list[i]);
        }
      }

      p = Print(list[1],account,list[3],list[2],list[13],details);
      pList.add(p);

    });
    return pList;
  }
}


