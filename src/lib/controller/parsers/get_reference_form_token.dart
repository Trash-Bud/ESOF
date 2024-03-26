import 'dart:developer';

import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/entities/expense.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

/// Parses information about the user's exams.
class GetReferenceFormToken {

  /// Extracts a list of exams from an HTTP [response].
  Future<String> getToken(http.Response response) async {
    final document = parse(response.body);
    final List<Element> elms = document.getElementsByTagName('input');
    String t;
    for(int i = 0; i < elms.length; i++ ){
      if(elms[i].attributes['name'] == "pv_check"){
        t = elms[i].attributes['value'];
      }
    }
    return t;
  }

  Future<String> getDate(http.Response response) async {
    final document = parse(response.body);
    final List<Element> elms = document.getElementsByTagName('input');
    String t;
    for(int i = 0; i < elms.length; i++ ){
      if(elms[i].attributes['name'] == "pv_data"){
        t = elms[i].attributes['value'];
      }
    }
    return t;
  }
}
