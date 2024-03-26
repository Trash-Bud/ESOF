import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

class ParserPrintingAccounts {

  /// Extracts a list of exams from an HTTP [response].
  Future<List<String>> parsePrintingAccounts(http.Response response) async {
    final document = parse(response.body);
    return  getAccounts(document);
  }

  List<String> getAccounts(Document document){
    final List<Element> list = document.getElementsByClassName('dados');
    List<String> accounts = [];
    if (list.isEmpty) return [];
    list[0].querySelectorAll('td').forEach((Element element) {
      if(element.className != ''){
        accounts.add(element.text);
      }
    });
    return accounts;
  }

}

